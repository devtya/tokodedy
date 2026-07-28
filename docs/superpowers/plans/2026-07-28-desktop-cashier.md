# Kasir Desktop Toko Dedy — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a keyboard-first, single-screen desktop (Windows) cashier page for Toko Dedy where a USB keyboard-wedge scanner drives the cart and confirming payment prints the receipt via a USB thermal printer, which auto-opens the cash drawer.

**Architecture:** Extract the existing ESC/POS byte builder out of `BluetoothPrinterService` into a pure `EscPosBuilder`, then put both the Bluetooth printer and a new Windows USB printer behind one `ReceiptPrinter` interface selected by platform in DI. The desktop cashier is a new page (`cashier_desktop_page.dart`) that reuses the existing `CashierBloc`, `ReceiptGenerator`, and use cases — only the layout and input model are new. Scanner input is just a focused `TextField` that submits on Enter (scanners append Enter by default); the drawer opens as a side effect of printing (kick command already inside the receipt bytes) plus a manual "Buka Laci" action.

**Tech Stack:** Flutter (Windows desktop), flutter_bloc, get_it/injectable, `printing` (already a dep — used to enumerate Windows printer names), `win32` + `ffi` (new deps — raw ESC/POS bytes to the Windows spooler).

## Global Constraints

- Design system is fixed: read colors from `Theme.of(context).colorScheme`; never hardcode hex. Source of truth `lib/core/theme/app_theme.dart` and `DESIGN.md`. Flat design (elevation 0 except FAB).
- Currency formatting: `NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0)`.
- Tap targets ≥ 48px; total amount is the largest text on the cashier screen.
- Do NOT modify the mobile `cashier_page.dart` / `cart_page.dart` behavior — desktop is additive.
- ESC/POS drawer kick payload is exactly `[0x1B, 0x70, 0x00, 0x19, 0xFA]` (from `bluetooth_printer_service.dart:337`).
- Reuse existing pieces: `CashierBloc` + events (`AddToCart`, `UpdateJumlahCart`, `RemoveFromCart`, `UpdateJumlahBayar`, `BayarCashier`), states (`CashierReady`, `CashierSuccess`, `CashierError`), `ReceiptGenerator.fromTransaction(...)`, `GetAllProduk`, `GetProdukByBarcode`, `PrinterSettings`.
- New deps must be pure-Dart (no extra native toolchain): `win32` and `ffi` qualify.

---

### Task 1: Extract ESC/POS builder into a pure, testable class

**Files:**
- Create: `lib/data/services/printing/esc_pos_builder.dart`
- Modify: `lib/data/services/bluetooth_printer_service.dart` (delete `_buildEscPos`, `_buildPickingListEscPos`, `formatReceiptItemLine`, `fontMode`; call the new builder)
- Test: `test/data/services/esc_pos_builder_test.dart`

**Interfaces:**
- Consumes: `ReceiptData`, `ReceiptItem` from `lib/data/models/receipt_data.dart`.
- Produces:
  - `class EscPosBuilder`
  - `List<int> EscPosBuilder.buildReceipt(ReceiptData data)` — full receipt incl. trailing drawer kick + cut.
  - `List<int> EscPosBuilder.buildPickingList(ReceiptData data)`
  - `List<int> EscPosBuilder.drawerKick()` — returns `[0x1B, 0x70, 0x00, 0x19, 0xFA]` only.

- [ ] **Step 1: Write the failing test**

```dart
// test/data/services/esc_pos_builder_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/data/models/receipt_data.dart';
import 'package:tokodedy/data/services/printing/esc_pos_builder.dart';

bool _containsSeq(List<int> haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var ok = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) { ok = false; break; }
    }
    if (ok) return true;
  }
  return false;
}

void main() {
  const builder = EscPosBuilder();
  final sample = ReceiptData(
    namaToko: 'Toko Dedy',
    transaksiId: 'TRX-1',
    tanggal: '01/01/2026 10:00',
    items: const [
      ReceiptItem(nama: 'Indomie - pcs', jumlah: 2, harga: 3000),
    ],
    subtotal: 6000,
    totalBayar: 6000,
    lebarKertas: 58,
  );

  test('drawerKick returns exactly the kick command', () {
    expect(const EscPosBuilder().drawerKick(), [0x1B, 0x70, 0x00, 0x19, 0xFA]);
  });

  test('buildReceipt starts with ESC @ init', () {
    final bytes = builder.buildReceipt(sample);
    expect(bytes.sublist(0, 2), [0x1B, 0x40]);
  });

  test('buildReceipt embeds the drawer kick so printing opens the drawer', () {
    final bytes = builder.buildReceipt(sample);
    expect(_containsSeq(bytes, [0x1B, 0x70, 0x00, 0x19, 0xFA]), isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/data/services/esc_pos_builder_test.dart`
Expected: FAIL — `esc_pos_builder.dart` does not exist (compile error / URI not found).

- [ ] **Step 3: Create `EscPosBuilder` by moving the existing byte logic**

Move the body of `_buildEscPos`, `_buildPickingListEscPos`, and their local helpers verbatim from `bluetooth_printer_service.dart` into methods on this class. The code below is that logic relocated (unchanged behavior).

```dart
// lib/data/services/printing/esc_pos_builder.dart
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../models/receipt_data.dart';

class EscPosBuilder {
  const EscPosBuilder();

  List<int> drawerKick() => [0x1B, 0x70, 0x00, 0x19, 0xFA];

  List<int> buildReceipt(ReceiptData data) {
    final buffer = <int>[];
    void add(List<int> bytes) => buffer.addAll(bytes);
    void addText(String text) => buffer.addAll(utf8.encode(text));

    final lebar = data.lebarKertas == 58 ? 32 : 48;

    int fontMode() {
      switch (data.fontSize) {
        case 'kecil':
          return 0x01;
        case 'besar':
          return 0x30;
        default:
          return 0x00;
      }
    }

    String formatReceiptItemLine(ReceiptItem item, int lebar) {
      final formatter = NumberFormat('#,##0.00', 'en_US');
      final priceStr = item.harga.toStringAsFixed(0);
      final qtyStr = 'x ${item.jumlah}';
      final String unitName;
      final parts = item.nama.split(' - ');
      if (parts.length > 1) {
        unitName = parts.sublist(1).join(' - ');
      } else {
        unitName = item.satuan ?? '';
      }
      final String unitPart;
      if (item.konversi > 1 && unitName.isNotEmpty) {
        unitPart = '${item.konversi.toInt()} $unitName';
      } else {
        unitPart = unitName;
      }
      final totalStr = formatter.format(item.harga * item.jumlah);
      if (lebar == 48) {
        final p = priceStr.padRight(14);
        final q = qtyStr.padRight(6);
        final u = unitPart.padLeft(8);
        final t = totalStr.padLeft(17);
        return '$p$q$u = $t';
      } else {
        final p = priceStr.padRight(8);
        final q = qtyStr.padRight(4);
        final u = unitPart.padLeft(6);
        final t = totalStr.padLeft(11);
        return '$p$q$u = $t';
      }
    }

    add([0x1B, 0x40]);
    add([0x1B, 0x61, 0x01]);
    add([0x1B, 0x21, 0x38]);
    addText(data.namaToko);
    add([0x0A]);
    add([0x1B, 0x21, fontMode()]);
    if (data.alamatToko.isNotEmpty) {
      addText(data.alamatToko);
      add([0x0A]);
    }
    add([0x0A]);
    add([0x1B, 0x61, 0x00]);
    addText('#${data.transaksiId}');
    add([0x0A]);
    addText('Tgl: ${data.tanggal}');
    add([0x0A]);
    if (data.kasir.isNotEmpty) {
      addText('Kasir: ${data.kasir}');
      add([0x0A]);
    }
    addText('Metode: ${data.metodePembayaran}');
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    for (final item in data.items) {
      final parts = item.nama.split(' - ');
      final namaProduk = parts.isNotEmpty ? parts[0] : item.nama;
      final nama =
          namaProduk.length > lebar ? namaProduk.substring(0, lebar) : namaProduk;
      add([0x1B, 0x61, 0x00]);
      addText(nama);
      add([0x0A]);
      addText(formatReceiptItemLine(item, lebar));
      add([0x0A]);
      if (item.diskon > 0) {
        add([0x1B, 0x61, 0x02]);
        addText('  Diskon: -${item.diskon.toStringAsFixed(0)}');
        add([0x0A]);
        add([0x1B, 0x61, 0x00]);
      }
    }
    addText('-' * lebar);
    add([0x0A]);
    add([0x1B, 0x61, 0x02]);
    add([0x1B, 0x21, 0x10 | fontMode()]);
    addText('Subtotal: ${data.subtotal.toStringAsFixed(0)}');
    add([0x0A]);
    if (data.totalDiskon > 0) {
      addText('Diskon: -${data.totalDiskon.toStringAsFixed(0)}');
      add([0x0A]);
    }
    add([0x1B, 0x21, 0x38]);
    addText('TOTAL: ${data.totalBayar.toStringAsFixed(0)}');
    add([0x0A]);
    add([0x1B, 0x21, 0x00]);
    add([0x0A]);
    addText('Dibayar: ${data.totalBayar.toStringAsFixed(0)}');
    add([0x0A]);
    if (data.kembalian > 0) {
      addText('Kembali: ${data.kembalian.toStringAsFixed(0)}');
      add([0x0A]);
    }
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    add([0x1B, 0x61, 0x01]);
    addText('Terima kasih atas kunjungan Anda!');
    add([0x0A, 0x0A, 0x0A]);
    add(drawerKick());
    add([0x1D, 0x56, 0x41, 0x03]);
    return buffer;
  }

  List<int> buildPickingList(ReceiptData data) {
    final buffer = <int>[];
    void add(List<int> bytes) => buffer.addAll(bytes);
    void addText(String text) => buffer.addAll(utf8.encode(text));
    final lebar = data.lebarKertas == 58 ? 32 : 48;
    add([0x1B, 0x40]);
    add([0x1B, 0x61, 0x01]);
    add([0x1B, 0x21, 0x38]);
    addText('DAFTAR PENGAMBILAN');
    add([0x0A]);
    add([0x1B, 0x21, 0x00]);
    addText(data.namaToko);
    add([0x0A, 0x0A]);
    add([0x1B, 0x61, 0x00]);
    addText('Pesanan: #${data.transaksiId}');
    add([0x0A]);
    addText('Tgl: ${data.tanggal}');
    add([0x0A]);
    addText('-' * lebar);
    add([0x0A]);
    for (final item in data.items) {
      final parts = item.nama.split(' - ');
      final namaProduk = parts.isNotEmpty ? parts[0] : item.nama;
      final String unitName;
      if (parts.length > 1) {
        unitName = parts.sublist(1).join(' - ');
      } else {
        unitName = item.satuan ?? 'Pcs';
      }
      final qtyPart = '${item.jumlah} $unitName';
      add([0x1B, 0x61, 0x00]);
      add([0x1B, 0x21, 0x10]);
      addText('[ ] $namaProduk');
      add([0x0A]);
      add([0x1B, 0x21, 0x00]);
      addText('    Qty: $qtyPart');
      add([0x0A, 0x0A]);
    }
    addText('-' * lebar);
    add([0x0A, 0x0A, 0x0A]);
    add([0x1D, 0x56, 0x41, 0x03]);
    return buffer;
  }
}
```

- [ ] **Step 4: Rewire `BluetoothPrinterService` to use the builder**

In `bluetooth_printer_service.dart`: add `import 'printing/esc_pos_builder.dart';`, delete the methods `_buildEscPos` and `_buildPickingListEscPos`, and replace their call sites:

```dart
// inside printReceipt(...)
final bytes = const EscPosBuilder().buildReceipt(data);
```
```dart
// inside printPickingList(...)
final bytes = const EscPosBuilder().buildPickingList(data);
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/data/services/esc_pos_builder_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Verify the app still compiles**

Run: `flutter analyze lib/data/services/bluetooth_printer_service.dart lib/data/services/printing/esc_pos_builder.dart`
Expected: No errors.

- [ ] **Step 7: Commit**

```bash
git add lib/data/services/printing/esc_pos_builder.dart lib/data/services/bluetooth_printer_service.dart test/data/services/esc_pos_builder_test.dart
git commit -m "refactor: extract ESC/POS builder into pure EscPosBuilder"
```

---

### Task 2: Define the `ReceiptPrinter` interface and make Bluetooth implement it

**Files:**
- Create: `lib/data/services/printing/receipt_printer.dart`
- Modify: `lib/data/services/bluetooth_printer_service.dart` (implement interface, add `openDrawer()`)
- Test: none (interface + thin delegation; covered by Task 1 and Task 3 byte tests)

**Interfaces:**
- Produces:
  - `abstract class ReceiptPrinter`
    - `Future<bool> isReady()`
    - `Future<bool> printReceipt(ReceiptData data)`
    - `Future<bool> openDrawer()`
  - `BluetoothPrinterService implements ReceiptPrinter` (already has `isConnected`, `printReceipt`).

- [ ] **Step 1: Create the interface**

```dart
// lib/data/services/printing/receipt_printer.dart
import '../../models/receipt_data.dart';

/// Platform-agnostic receipt printer. Implementations: Bluetooth (Android),
/// Windows USB spooler. Printing a receipt also opens the cash drawer because
/// the drawer kick is embedded in the receipt bytes; [openDrawer] fires the
/// kick alone (manual "Buka Laci").
abstract class ReceiptPrinter {
  Future<bool> isReady();
  Future<bool> printReceipt(ReceiptData data);
  Future<bool> openDrawer();
}
```

- [ ] **Step 2: Make `BluetoothPrinterService` implement it and add `openDrawer`**

Change the class declaration and add the method:

```dart
// bluetooth_printer_service.dart
import 'printing/receipt_printer.dart';
// ...
@lazySingleton
class BluetoothPrinterService implements ReceiptPrinter {
  // ...existing members...

  @override
  Future<bool> isReady() => isConnected();

  @override
  Future<bool> openDrawer() async {
    if (!await isConnected()) return false;
    await _writeBytes(const EscPosBuilder().drawerKick());
    return true;
  }
}
```
(`printReceipt` and `isConnected` already exist; just add `@override` on `printReceipt`.)

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/data/services/bluetooth_printer_service.dart`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/data/services/printing/receipt_printer.dart lib/data/services/bluetooth_printer_service.dart
git commit -m "feat: add ReceiptPrinter interface, Bluetooth impl + openDrawer"
```

---

### Task 3: Windows USB printer service (raw ESC/POS to the spooler)

**Files:**
- Modify: `pubspec.yaml` (add `win32`, `ffi`)
- Modify: `lib/data/services/printer_settings.dart` (expose the Windows printer name — reuse `deviceAddress`)
- Create: `lib/data/services/printing/windows_printer_service.dart`
- Test: `test/data/services/windows_printer_service_test.dart`

**Interfaces:**
- Consumes: `ReceiptPrinter`, `EscPosBuilder`, `PrinterSettings`.
- Produces:
  - `WindowsPrinterService implements ReceiptPrinter`
  - static `Future<List<String>> WindowsPrinterService.listPrinterNames()` — via the `printing` package.
  - `String PrinterSettings.windowsPrinterName` (getter/setter aliasing `deviceAddress`).

- [ ] **Step 1: Add dependencies**

Run:
```bash
flutter pub add win32 ffi
```
Expected: `pubspec.yaml` gains `win32:` and `ffi:` under dependencies; `flutter pub get` succeeds.

- [ ] **Step 2: Add a readable alias on PrinterSettings**

On Windows `deviceAddress` holds the Windows printer name. Add to `printer_settings.dart`:

```dart
String get windowsPrinterName => deviceAddress;
set windowsPrinterName(String v) => deviceAddress = v;
```

- [ ] **Step 3: Write the failing test (pure payload, no hardware)**

```dart
// test/data/services/windows_printer_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/data/services/printing/windows_printer_service.dart';

void main() {
  test('rawBytesForDrawer is exactly the kick command', () {
    expect(WindowsPrinterService.rawBytesForDrawer(),
        [0x1B, 0x70, 0x00, 0x19, 0xFA]);
  });
}
```

- [ ] **Step 4: Run test to verify it fails**

Run: `flutter test test/data/services/windows_printer_service_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 5: Implement the Windows printer service**

```dart
// lib/data/services/printing/windows_printer_service.dart
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:printing/printing.dart';
import 'package:win32/win32.dart';

import '../../../core/di/injection.dart';
import '../../models/receipt_data.dart';
import '../printer_settings.dart';
import 'esc_pos_builder.dart';
import 'receipt_printer.dart';

@lazySingleton
class WindowsPrinterService implements ReceiptPrinter {
  static const _builder = EscPosBuilder();

  static List<int> rawBytesForDrawer() => const EscPosBuilder().drawerKick();

  /// Names of installed Windows printers (for the settings dropdown).
  static Future<List<String>> listPrinterNames() async {
    final printers = await Printing.listPrinters();
    return printers.map((p) => p.name).toList();
  }

  @override
  Future<bool> isReady() async {
    final name = sl<PrinterSettings>().windowsPrinterName;
    if (name.isEmpty) return false;
    final names = await listPrinterNames();
    return names.contains(name);
  }

  @override
  Future<bool> printReceipt(ReceiptData data) =>
      _sendRaw(_builder.buildReceipt(data));

  @override
  Future<bool> openDrawer() => _sendRaw(_builder.drawerKick());

  /// Sends raw bytes straight to the Windows print spooler as datatype RAW,
  /// which the thermal printer interprets as ESC/POS.
  Future<bool> _sendRaw(List<int> bytes) async {
    final printerName = sl<PrinterSettings>().windowsPrinterName;
    if (printerName.isEmpty) return false;

    final pName = printerName.toNativeUtf16();
    final phPrinter = calloc<HANDLE>();
    final docName = 'Receipt'.toNativeUtf16();
    final dataType = 'RAW'.toNativeUtf16();
    final docInfo = calloc<DOC_INFO_1>();
    final pBytes = calloc<Uint8>(bytes.length);
    final written = calloc<DWORD>();
    try {
      if (OpenPrinter(pName, phPrinter, nullptr) == 0) return false;
      final hPrinter = phPrinter.value;
      docInfo.ref
        ..pDocName = docName
        ..pOutputFile = nullptr
        ..pDatatype = dataType;
      if (StartDocPrinter(hPrinter, 1, docInfo) == 0) {
        ClosePrinter(hPrinter);
        return false;
      }
      StartPagePrinter(hPrinter);
      pBytes.asTypedList(bytes.length).setAll(0, bytes);
      final ok =
          WritePrinter(hPrinter, pBytes.cast(), bytes.length, written) != 0;
      EndPagePrinter(hPrinter);
      EndDocPrinter(hPrinter);
      ClosePrinter(hPrinter);
      return ok;
    } catch (_) {
      return false;
    } finally {
      calloc.free(pName);
      calloc.free(phPrinter);
      calloc.free(docName);
      calloc.free(dataType);
      calloc.free(docInfo);
      calloc.free(pBytes);
      calloc.free(written);
    }
  }
}
```

Note for implementer: if `win32`'s `StartDocPrinter` signature expects `Pointer<Uint8>` rather than `Pointer<DOC_INFO_1>`, cast with `docInfo.cast()`. Verify against the installed `win32` version's `WritePrinter`/`StartDocPrinter` typedefs and adjust the cast only (logic unchanged).

- [ ] **Step 6: Run test to verify it passes**

Run: `flutter test test/data/services/windows_printer_service_test.dart`
Expected: PASS.

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock lib/data/services/printer_settings.dart lib/data/services/printing/windows_printer_service.dart test/data/services/windows_printer_service_test.dart
git commit -m "feat: Windows USB ESC/POS printer service (raw spooler print + drawer)"
```

---

### Task 4: Register `ReceiptPrinter` by platform in DI

**Files:**
- Create: `lib/core/di/printer_module.dart`
- Modify: `lib/core/di/injection.dart` (ensure the module is picked up / manual registration)
- Test: none (wiring; validated by app build in later tasks)

**Interfaces:**
- Produces: `sl<ReceiptPrinter>()` resolves to `WindowsPrinterService` on Windows, else `BluetoothPrinterService`.

- [ ] **Step 1: Add a manual registration helper**

The project uses injectable; both services are `@lazySingleton` (concrete). Bind the interface manually so `sl<ReceiptPrinter>()` works. Add this function and call it right after `configureDependencies()` in `injection.dart`:

```dart
// lib/core/di/printer_module.dart
import 'dart:io' show Platform;
import '../../data/services/bluetooth_printer_service.dart';
import '../../data/services/printing/receipt_printer.dart';
import '../../data/services/printing/windows_printer_service.dart';
import 'injection.dart';

void registerReceiptPrinter() {
  if (sl.isRegistered<ReceiptPrinter>()) return;
  sl.registerLazySingleton<ReceiptPrinter>(
    () => Platform.isWindows
        ? sl<WindowsPrinterService>()
        : sl<BluetoothPrinterService>(),
  );
}
```

- [ ] **Step 2: Call it during startup**

In `lib/core/di/injection.dart`, after the generated `configureDependencies()` runs (in the `configureDependencies`/init function), add:

```dart
import 'printer_module.dart';
// ... after $initGetIt(getIt) / configureDependencies():
registerReceiptPrinter();
```

- [ ] **Step 3: Verify it compiles and DI resolves**

Run: `flutter analyze lib/core/di/printer_module.dart`
Expected: No errors.

- [ ] **Step 4: Commit**

```bash
git add lib/core/di/printer_module.dart lib/core/di/injection.dart
git commit -m "feat: bind ReceiptPrinter to platform-specific impl in DI"
```

---

### Task 5: Pure scan-resolution logic

**Files:**
- Create: `lib/presentation/pages/desktop/scan_resolver.dart`
- Test: `test/presentation/desktop/scan_resolver_test.dart`

**Interfaces:**
- Consumes: `Produk` (`lib/domain/entities/produk.dart`), `AddToCart` event.
- Produces:
  - `enum ScanOutcome { added, notFound, archived, outOfStock }`
  - `class ScanResult { final ScanOutcome outcome; final AddToCart? event; }`
  - `ScanResult resolveScannedProduct(Produk? p, {required bool isKasir})` — base unit, qty 1. `hargaPokok` is 0 for kasir, else `p.hargaBeli`.

- [ ] **Step 1: Write the failing test**

```dart
// test/presentation/desktop/scan_resolver_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/domain/entities/produk.dart';
import 'package:tokodedy/presentation/pages/desktop/scan_resolver.dart';

Produk _p({int stok = 5, bool archived = false}) => Produk(
      id: 'p1',
      tokoId: 't1',
      nama: 'Indomie',
      hargaBeli: 2500,
      hargaJual: 3000,
      stok: stok,
      satuan: 'pcs',
      isArchived: archived,
    );

void main() {
  test('null product -> notFound', () {
    expect(resolveScannedProduct(null, isKasir: false).outcome,
        ScanOutcome.notFound);
  });

  test('archived -> archived', () {
    expect(resolveScannedProduct(_p(archived: true), isKasir: false).outcome,
        ScanOutcome.archived);
  });

  test('zero stock -> outOfStock', () {
    expect(resolveScannedProduct(_p(stok: 0), isKasir: false).outcome,
        ScanOutcome.outOfStock);
  });

  test('valid -> added with qty 1 and base unit', () {
    final r = resolveScannedProduct(_p(), isKasir: false);
    expect(r.outcome, ScanOutcome.added);
    expect(r.event!.produkId, 'p1');
    expect(r.event!.jumlah, 1);
    expect(r.event!.hargaJual, 3000);
    expect(r.event!.hargaPokok, 2500);
  });

  test('kasir role hides cost (hargaPokok 0)', () {
    final r = resolveScannedProduct(_p(), isKasir: true);
    expect(r.event!.hargaPokok, 0);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/desktop/scan_resolver_test.dart`
Expected: FAIL — file does not exist. (If the `Produk` constructor args differ, fix the `_p` helper to match the real constructor before proceeding — check `lib/domain/entities/produk.dart`.)

- [ ] **Step 3: Implement the resolver**

```dart
// lib/presentation/pages/desktop/scan_resolver.dart
import '../../../domain/entities/produk.dart';
import '../../blocs/cashier/cashier_event.dart';

enum ScanOutcome { added, notFound, archived, outOfStock }

class ScanResult {
  final ScanOutcome outcome;
  final AddToCart? event;
  const ScanResult(this.outcome, [this.event]);
}

ScanResult resolveScannedProduct(Produk? p, {required bool isKasir}) {
  if (p == null) return const ScanResult(ScanOutcome.notFound);
  if (p.isArchived) return const ScanResult(ScanOutcome.archived);
  if (p.stok <= 0) return const ScanResult(ScanOutcome.outOfStock);
  return ScanResult(
    ScanOutcome.added,
    AddToCart(
      produkId: p.id!,
      namaProduk: '${p.nama} - ${p.satuan ?? 'pcs'}',
      hargaJual: p.hargaJual,
      hargaPokok: isKasir ? 0.0 : p.hargaBeli,
      jumlah: 1,
      konversi: 1.0,
    ),
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/desktop/scan_resolver_test.dart`
Expected: PASS (5 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/pages/desktop/scan_resolver.dart test/presentation/desktop/scan_resolver_test.dart
git commit -m "feat: pure scan-resolution logic for desktop cashier"
```

---

### Task 6: Desktop cashier page — 2-panel layout, scan field, product grid

**Files:**
- Create: `lib/presentation/pages/desktop/cashier_desktop_page.dart`
- Create: `lib/presentation/pages/desktop/widgets/cart_panel.dart`
- Test: `test/presentation/desktop/cashier_desktop_smoke_test.dart`

**Interfaces:**
- Consumes: `CashierBloc`, `GetAllProduk`, `GetProdukByBarcode`, `resolveScannedProduct`, `CartPanel`.
- Produces:
  - `class CashierDesktopPage extends StatefulWidget` (expects an ancestor `BlocProvider<CashierBloc>`).
  - `class CartPanel extends StatelessWidget` — `CartPanel({required this.data, required this.onPay, required this.onRemove, required this.onEditQty})` where `data` is `CashierReady`, `onPay` is `VoidCallback`, `onRemove` is `void Function(int index)`, `onEditQty` is `void Function(int index, int newQty)`.

- [ ] **Step 1: Build the cart panel (right column)**

```dart
// lib/presentation/pages/desktop/widgets/cart_panel.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../blocs/cashier/cashier_state.dart';

class CartPanel extends StatelessWidget {
  final CashierReady data;
  final VoidCallback onPay;
  final void Function(int index) onRemove;
  final void Function(int index, int newQty) onEditQty;
  const CartPanel({
    super.key,
    required this.data,
    required this.onPay,
    required this.onRemove,
    required this.onEditQty,
  });

  static final _rp =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Keranjang',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          Expanded(
            child: data.cart.isEmpty
                ? Center(
                    child: Text('Belum ada barang',
                        style: TextStyle(color: cs.onSurfaceVariant)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: data.cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = data.cart[i];
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 4),
                        title: Text(item.namaProduk),
                        subtitle: Text(
                            '${_rp.format(item.hargaJual)} x ${item.jumlah}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () =>
                                  onEditQty(i, item.jumlah - 1),
                            ),
                            Text('${item.jumlah}'),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () =>
                                  onEditQty(i, item.jumlah + 1),
                            ),
                            SizedBox(
                              width: 90,
                              child: Text(_rp.format(item.subtotal),
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ),
                            IconButton(
                              icon: Icon(Icons.close,
                                  size: 18, color: cs.error),
                              onPressed: () => onRemove(i),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text(
                      _rp.format(data.totalSetelahDiskon),
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: cs.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: data.cart.isEmpty ? null : onPay,
                    child: Text(
                        'F9 · BAYAR  (${_rp.format(data.totalSetelahDiskon)})',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Build the desktop page shell (header + scan field + grid + CartPanel)**

```dart
// lib/presentation/pages/desktop/cashier_desktop_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/produk.dart';
import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/cashier/cashier_bloc.dart';
import '../../blocs/cashier/cashier_event.dart';
import '../../blocs/cashier/cashier_state.dart';
import 'scan_resolver.dart';
import 'widgets/cart_panel.dart';

class CashierDesktopPage extends StatefulWidget {
  const CashierDesktopPage({super.key});
  @override
  State<CashierDesktopPage> createState() => _CashierDesktopPageState();
}

class _CashierDesktopPageState extends State<CashierDesktopPage> {
  final _scanCtrl = TextEditingController();
  final _scanFocus = FocusNode();
  final _rp =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

  List<Produk> _all = [];
  List<Produk> _filtered = [];

  bool get _isKasir {
    final s = context.read<AuthBloc>().state;
    return s is Authenticated && s.user.isKasir;
  }

  @override
  void initState() {
    super.initState();
    context.read<CashierBloc>().add(InitCashier());
    _loadProducts();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scanFocus.requestFocus());
  }

  @override
  void dispose() {
    _scanCtrl.dispose();
    _scanFocus.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final products = await sl<GetAllProduk>()();
    final active = products.where((p) => !p.isArchived).toList()
      ..sort((a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()));
    if (!mounted) return;
    setState(() {
      _all = active;
      _filtered = active;
    });
  }

  void _filter(String q) {
    final query = q.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _all
          : _all
              .where((p) => p.nama.toLowerCase().contains(query))
              .toList();
    });
  }

  Future<void> _onSubmitScan(String raw) async {
    final code = raw.trim();
    _scanCtrl.clear();
    _refocus();
    if (code.isEmpty) return;
    final produk = await sl<GetProdukByBarcode>()(code);
    final result = resolveScannedProduct(produk, isKasir: _isKasir);
    if (!mounted) return;
    switch (result.outcome) {
      case ScanOutcome.added:
        context.read<CashierBloc>().add(result.event!);
        break;
      case ScanOutcome.notFound:
        _flash('Barcode "$code" tidak ditemukan');
        break;
      case ScanOutcome.archived:
        _flash('Produk diarsipkan, tidak bisa dijual');
        break;
      case ScanOutcome.outOfStock:
        _flash('Stok habis');
        break;
    }
  }

  void _addProduct(Produk p) {
    final r = resolveScannedProduct(p, isKasir: _isKasir);
    if (r.outcome == ScanOutcome.added) {
      context.read<CashierBloc>().add(r.event!);
    } else {
      _flash('Stok habis');
    }
    _refocus();
  }

  void _flash(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _refocus() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _scanFocus.requestFocus());

  CashierReady _data(CashierState s) {
    if (s is CashierReady) return s;
    if (s is CashierError) {
      return CashierReady(cart: s.cart, jumlahBayar: s.jumlahBayar);
    }
    return const CashierReady();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<CashierBloc, CashierState>(
      builder: (context, state) {
        final data = _data(state);
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _scanCtrl,
                        focusNode: _scanFocus,
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.qr_code_scanner),
                          hintText: 'Scan / ketik barcode, lalu Enter…',
                          filled: true,
                          fillColor: cs.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onSubmitted: _onSubmitScan,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: const InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari produk (F2)…',
                        ),
                        onChanged: _filter,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _buildGrid()),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: CartPanel(
                  data: data,
                  onPay: () {}, // wired in Task 7
                  onRemove: (i) =>
                      context.read<CashierBloc>().add(RemoveFromCart(i)),
                  onEditQty: (i, q) {
                    if (q <= 0) {
                      context.read<CashierBloc>().add(RemoveFromCart(i));
                    } else {
                      context
                          .read<CashierBloc>()
                          .add(UpdateJumlahCart(i, q));
                    }
                    _refocus();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid() {
    if (_filtered.isEmpty) {
      return const Center(child: Text('Produk tidak ada'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, i) {
        final p = _filtered[i];
        final habis = p.stok <= 0;
        return InkWell(
          onTap: habis ? null : () => _addProduct(p),
          borderRadius: BorderRadius.circular(12),
          child: Opacity(
            opacity: habis ? 0.5 : 1,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontWeight: FontWeight.w700)),
                    Text(_rp.format(p.hargaJual),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700)),
                    Text(habis ? 'Stok habis' : 'Stok ${p.stok}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 3: Write a smoke test**

```dart
// test/presentation/desktop/cashier_desktop_smoke_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/presentation/blocs/cashier/cashier_state.dart';
import 'package:tokodedy/presentation/pages/desktop/widgets/cart_panel.dart';

void main() {
  testWidgets('CartPanel shows total and disables pay when empty',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CartPanel(
          data: const CashierReady(),
          onPay: () {},
          onRemove: (_) {},
          onEditQty: (_, __) {},
        ),
      ),
    ));
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Belum ada barang'), findsOneWidget);
    final payBtn = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(payBtn.onPressed, isNull);
  });
}
```

- [ ] **Step 4: Run the smoke test**

Run: `flutter test test/presentation/desktop/cashier_desktop_smoke_test.dart`
Expected: PASS.

- [ ] **Step 5: Verify the page compiles**

Run: `flutter analyze lib/presentation/pages/desktop/`
Expected: No errors.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/pages/desktop/ test/presentation/desktop/cashier_desktop_smoke_test.dart
git commit -m "feat: desktop cashier page shell — scan field, product grid, cart panel"
```

---

### Task 7: Payment dialog, print+drawer on success, Buka Laci, printer status, keyboard shortcuts

**Files:**
- Create: `lib/presentation/pages/desktop/widgets/payment_dialog.dart`
- Modify: `lib/presentation/pages/desktop/cashier_desktop_page.dart` (wire `onPay`, success listener, header actions, shortcuts)
- Test: `test/presentation/desktop/payment_change_test.dart`

**Interfaces:**
- Consumes: `CashierBloc`, `ReceiptPrinter` (`sl<ReceiptPrinter>()`), `ReceiptGenerator`, `PrinterSettings`.
- Produces:
  - `Future<double?> showPaymentDialog(BuildContext context, {required double total})` — returns the amount paid, or null if cancelled. Only returns a value when paid ≥ total.
  - `double hitungKembalian(double bayar, double total)` — pure helper.

- [ ] **Step 1: Write the failing test for the change helper**

```dart
// test/presentation/desktop/payment_change_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tokodedy/presentation/pages/desktop/widgets/payment_dialog.dart';

void main() {
  test('kembalian is bayar minus total when sufficient', () {
    expect(hitungKembalian(50000, 32000), 18000);
  });
  test('kembalian is 0 when short', () {
    expect(hitungKembalian(10000, 32000), 0);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/presentation/desktop/payment_change_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Implement the payment dialog + helper**

```dart
// lib/presentation/pages/desktop/widgets/payment_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double hitungKembalian(double bayar, double total) =>
    bayar >= total ? bayar - total : 0;

final _rp = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);

Future<double?> showPaymentDialog(BuildContext context,
    {required double total}) {
  return showDialog<double>(
    context: context,
    builder: (ctx) {
      double bayar = 0;
      final ctrl = TextEditingController();
      void setBayar(StateSetter s, double v) {
        s(() {
          bayar = v;
          ctrl.text = v.toStringAsFixed(0);
          ctrl.selection =
              TextSelection.collapsed(offset: ctrl.text.length);
        });
      }

      return StatefulBuilder(
        builder: (ctx, setS) {
          final kembali = hitungKembalian(bayar, total);
          final cukup = bayar >= total;
          void confirm() {
            if (cukup) Navigator.pop(ctx, bayar);
          }

          return AlertDialog(
            title: const Text('Pembayaran'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text(_rp.format(total),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: ctrl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        prefixText: 'Rp ', labelText: 'Jumlah bayar'),
                    onChanged: (v) =>
                        setS(() => bayar = double.tryParse(v) ?? 0),
                    onSubmitted: (_) => confirm(),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => setBayar(setS, total),
                        child: const Text('Uang Pas'),
                      ),
                      for (final a in [20000.0, 50000.0, 100000.0])
                        OutlinedButton(
                          onPressed: () => setBayar(setS, a),
                          child: Text(_rp.format(a)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cukup ? 'Kembalian' : 'Kurang'),
                      Text(
                        _rp.format(cukup ? kembali : total - bayar),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: cukup
                              ? Theme.of(ctx).colorScheme.primary
                              : Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal (Esc)')),
              FilledButton(
                  onPressed: cukup ? confirm : null,
                  child: const Text('Bayar (Enter)')),
            ],
          );
        },
      );
    },
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/presentation/desktop/payment_change_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Wire payment + print/drawer + success flow in the desktop page**

In `cashier_desktop_page.dart`, add imports:

```dart
import '../../../data/services/printing/receipt_printer.dart';
import '../../../data/services/receipt_generator.dart';
import '../../../data/services/printer_settings.dart';
import '../../../domain/usecases/transaksi/buat_transaksi.dart' show CartItem;
import 'widgets/payment_dialog.dart';
```

Add fields to `_CashierDesktopPageState`:

```dart
List<CartItem>? _lastCart;
double _lastBayar = 0;
double _lastKembali = 0;
```

Replace the `onPay: () {},` in `CartPanel` with `onPay: () => _pay(data),` and add these methods:

```dart
Future<void> _pay(CashierReady data) async {
  if (data.cart.isEmpty) return;
  final bayar = await showPaymentDialog(context, total: data.totalSetelahDiskon);
  if (bayar == null || !mounted) return;
  _lastCart = List.from(data.cart);
  _lastBayar = bayar;
  _lastKembali = bayar - data.totalSetelahDiskon;
  context.read<CashierBloc>().add(UpdateJumlahBayar(bayar));
  context.read<CashierBloc>().add(const BayarCashier());
}

Future<void> _onSuccess(String transaksiId) async {
  final settings = sl<PrinterSettings>();
  final receipt = ReceiptGenerator(
    namaToko: settings.namaToko,
    alamatToko: settings.alamatToko,
    lebarKertas: settings.lebarKertas,
    fontSize: settings.fontSize,
  ).fromTransaction(
    transaksiId: transaksiId,
    cartItems: _lastCart ?? [],
    totalBayar: _lastBayar,
    kembalian: _lastKembali,
  );
  bool printed = false;
  try {
    printed = await sl<ReceiptPrinter>().printReceipt(receipt);
  } catch (_) {
    printed = false;
  }
  if (!mounted) return;
  if (printed) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Text('Lunas — kembali ${_rp.format(_lastKembali)}'),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.error,
      content: const Text(
          'Transaksi tersimpan, tapi struk gagal cetak & laci tidak terbuka'),
    ));
  }
  _lastCart = null;
  context.read<CashierBloc>().add(InitCashier());
  _refocus();
}

Future<void> _bukaLaci() async {
  final ok = await sl<ReceiptPrinter>().openDrawer();
  if (!mounted) return;
  if (!ok) {
    _flash('Gagal buka laci — printer tidak siap');
  }
  _refocus();
}
```

Change the top-level `BlocBuilder` to `BlocConsumer` and add the listener:

```dart
return BlocConsumer<CashierBloc, CashierState>(
  listener: (context, state) {
    if (state is CashierSuccess) _onSuccess(state.transaksiId);
    if (state is CashierError) _flash(state.message);
  },
  builder: (context, state) {
    // ...unchanged body...
  },
);
```

- [ ] **Step 6: Add the header (printer status + Buka Laci) and keyboard shortcuts**

Wrap the `Scaffold` body `Row` in a `CallbackShortcuts` and give the Scaffold an `AppBar`. Replace `Scaffold(body: Row(...))` with:

```dart
return CallbackShortcuts(
  bindings: {
    const SingleActivator(LogicalKeyboardKey.f9): () {
      if (data.cart.isNotEmpty) _pay(data);
    },
    const SingleActivator(LogicalKeyboardKey.f2): () => _scanFocus.requestFocus(),
  },
  child: Focus(
    autofocus: true,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        actions: [
          FutureBuilder<bool>(
            future: sl<ReceiptPrinter>().isReady(),
            builder: (context, snap) {
              final ready = snap.data ?? false;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  avatar: Icon(Icons.print,
                      size: 16,
                      color: ready
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error),
                  label: Text(ready ? 'Printer siap' : 'Printer putus'),
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: _bukaLaci,
            icon: const Icon(Icons.point_of_sale),
            label: const Text('Buka Laci'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(/* ...unchanged... */),
    ),
  ),
);
```

Add `import 'package:flutter/services.dart';` for `LogicalKeyboardKey`.

- [ ] **Step 7: Run tests and analyze**

Run: `flutter test test/presentation/desktop/ && flutter analyze lib/presentation/pages/desktop/`
Expected: All tests PASS; no analyzer errors.

- [ ] **Step 8: Commit**

```bash
git add lib/presentation/pages/desktop/ test/presentation/desktop/payment_change_test.dart
git commit -m "feat: desktop payment dialog, print+drawer on paid, Buka Laci, F9/F2 shortcuts"
```

---

### Task 8: Route to the desktop cashier on Windows / wide screens

**Files:**
- Modify: the call site(s) that push the cashier. Locate with the search below (expected: `home_page.dart`).
- Test: none (routing glue; validated by launching the app).

**Interfaces:**
- Consumes: `CashierDesktopPage`, existing `CashierPage`, existing `CashierBloc` provider setup used at the current push site.

- [ ] **Step 1: Find where the cashier is opened**

Run: `grep -rn "CashierPage(" lib/presentation`
Expected: at least one `MaterialPageRoute(builder: ... CashierPage())` (likely in `home_page.dart`).

- [ ] **Step 2: Choose the page by platform + width**

At that push site, keep the exact same `BlocProvider`/argument wrapping already used for `CashierPage`, but swap the child widget. Example (adapt to the real wrapper found in Step 1):

```dart
import 'dart:io' show Platform;
import '../desktop/cashier_desktop_page.dart';
// ...
Widget cashierChild() {
  final wide = MediaQuery.of(context).size.width >= 900;
  return (Platform.isWindows && wide)
      ? const CashierDesktopPage()
      : const CashierPage();
}
// use cashierChild() where `const CashierPage()` was, inside the same
// BlocProvider<CashierBloc> that already wraps the route.
```

If `CashierPage` was pushed without an explicit `BlocProvider<CashierBloc>` (i.e. it created its own), wrap the route in `BlocProvider(create: (_) => sl<CashierBloc>(), child: cashierChild())` so both pages get the bloc identically.

- [ ] **Step 3: Manually launch on Windows and smoke-test the flow**

Run:
```bash
flutter run -d windows
```
Verify: scan/typing a barcode + Enter adds a row; F9 opens payment; "Uang Pas" then Enter closes it; a success flash appears; "Buka Laci" button reacts. (Printing/drawer require real hardware; without it, expect the "struk gagal cetak" flash — that is correct behavior.)

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/pages/shared/home_page.dart
git commit -m "feat: open desktop cashier on Windows wide screens"
```

---

## Self-Review Notes

- **Spec coverage:** 2-panel layout (Task 6), always-focused scan field submitting on Enter (Task 6), product grid fallback (Task 6), scan→add base unit (Task 5/6), payment modal with keypad/quick-cash + live change (Task 7), print→drawer auto-open (Tasks 1–4, 7), manual Buka Laci (Tasks 2/3/7), printer status in header (Task 7), F9/F2 shortcuts (Task 7), USB Windows printer + keyboard-wedge scanner model (Tasks 3, 6), platform routing (Task 8). Cross-platform printer abstraction (Tasks 2–4). All spec items mapped.
- **Deferred (YAGNI, not in approved scope):** customer-facing second display; ↑/↓ row selection + `+`/`-`/`Del` on selected row (cart has on-row buttons instead — add if bench testing shows it's slower); F4 pending on desktop (mobile pending flow already exists and is reachable). Add these only if the shop asks after using v1.
- **Type consistency:** `resolveScannedProduct` / `ScanResult` / `ScanOutcome` used identically in Tasks 5 and 6; `CartPanel` constructor signature identical in Tasks 6 and its test; `ReceiptPrinter` methods (`isReady`, `printReceipt`, `openDrawer`) consistent across Tasks 2, 3, 4, 7; `hitungKembalian` signature consistent in Task 7 and its test.
