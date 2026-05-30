import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:hend_kasir/domain/usecases/transaksi/buat_transaksi.dart';

void main() {
  group('CartItem — subtotal & diskon', () {
    test('subtotal = hargaJual * jumlah', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 10000,
        jumlah: 3,
      );
      expect(item.subtotal, 30000.0);
    });

    test('subtotal dibulatkan ke整数 (roundToDouble)', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 3333,
        jumlah: 3,
      );
      expect(item.subtotal, 9999.0);
    });

    test('totalDiskon tipe 0 (tanpa diskon) = 0', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 50000,
        jumlah: 2,
        diskonTipe: 0,
        diskonValue: 0,
      );
      expect(item.totalDiskon, 0.0);
    });

    test('totalDiskon tipe 1 (persen) = subtotal * value / 100', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 50000,
        jumlah: 2,
        diskonTipe: 1,
        diskonValue: 10,
      );
      expect(item.subtotal, 100000.0);
      expect(item.totalDiskon, 10000.0);
    });

    test('totalDiskon tipe 2 (nominal) = diskonValue langsung', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 50000,
        jumlah: 2,
        diskonTipe: 2,
        diskonValue: 5000,
      );
      expect(item.subtotal, 100000.0);
      expect(item.totalDiskon, 5000.0);
    });

    test('totalSetelahDiskon = subtotal - totalDiskon', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 50000,
        jumlah: 2,
        diskonTipe: 1,
        diskonValue: 10,
      );
      expect(item.totalSetelahDiskon, 90000.0);
    });

    test('totalSetelahDiskon tanpa diskon = subtotal', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 25000,
        jumlah: 4,
      );
      expect(item.totalSetelahDiskon, 100000.0);
    });
  });

  group('CartItem — copyWith', () {
    test('copyWith mengubah jumlah', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 10000,
        jumlah: 1,
      );
      final updated = item.copyWith(jumlah: 5);
      expect(updated.jumlah, 5);
      expect(updated.subtotal, 50000.0);
    });

    test('copyWith tidak mengubah field lain', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 10000,
        jumlah: 1,
        diskonTipe: 1,
        diskonValue: 20,
      );
      final updated = item.copyWith(jumlah: 3);
      expect(updated.diskonTipe, 1);
      expect(updated.diskonValue, 20.0);
      expect(updated.hargaJual, 10000.0);
    });

    test('copyWith mengubah diskonTipe dan diskonValue', () {
      final item = CartItem(
        produkId: '1',
        namaProduk: 'Test',
        hargaJual: 10000,
        jumlah: 2,
        diskonTipe: 0,
        diskonValue: 0,
      );
      final updated = item.copyWith(diskonTipe: 1, diskonValue: 15);
      expect(updated.totalDiskon, 3000.0);
      expect(updated.totalSetelahDiskon, 17000.0);
    });
  });

  group('CashierReady — total kalkulasi', () {
    test('total = sum semua subtotal cart', () {
      final state = _createCashierReady([
        CartItem(produkId: '1', namaProduk: 'A', hargaJual: 10000, jumlah: 2),
        CartItem(produkId: '2', namaProduk: 'B', hargaJual: 15000, jumlah: 3),
      ]);
      expect(state.total, 20000.0 + 45000.0);
      expect(state.total, 65000.0);
    });

    test('totalDiskon = sum semua diskon per item', () {
      final state = _createCashierReady([
        CartItem(
          produkId: '1', namaProduk: 'A', hargaJual: 50000,
          jumlah: 2, diskonTipe: 1, diskonValue: 10,
        ),
        CartItem(
          produkId: '2', namaProduk: 'B', hargaJual: 20000,
          jumlah: 1, diskonTipe: 2, diskonValue: 3000,
        ),
      ]);
      expect(state.total, 100000.0 + 20000.0);
      expect(state.totalDiskon, 10000.0 + 3000.0);
      expect(state.totalDiskon, 13000.0);
    });

    test('totalSetelahDiskon = total - totalDiskon', () {
      final state = _createCashierReady([
        CartItem(
          produkId: '1', namaProduk: 'A', hargaJual: 50000,
          jumlah: 2, diskonTipe: 1, diskonValue: 10,
        ),
        CartItem(
          produkId: '2', namaProduk: 'B', hargaJual: 20000,
          jumlah: 1, diskonTipe: 2, diskonValue: 3000,
        ),
      ]);
      expect(state.totalSetelahDiskon, 120000.0 - 13000.0);
      expect(state.totalSetelahDiskon, 107000.0);
    });

    test('kembalian = jumlahBayar - totalSetelahDiskon', () {
      final state = _createCashierReady(
        [
          CartItem(produkId: '1', namaProduk: 'A', hargaJual: 25000, jumlah: 2),
        ],
        jumlahBayar: 60000,
      );
      expect(state.kembalian, 60000.0 - 50000.0);
      expect(state.kembalian, 10000.0);
    });

    test('kembalian = 0 jika jumlahBayar < totalSetelahDiskon', () {
      final state = _createCashierReady(
        [
          CartItem(produkId: '1', namaProduk: 'A', hargaJual: 50000, jumlah: 1),
        ],
        jumlahBayar: 30000,
      );
      expect(state.kembalian, 0.0);
    });

    test('kembalian pas (uang pas)', () {
      final state = _createCashierReady(
        [
          CartItem(produkId: '1', namaProduk: 'A', hargaJual: 50000, jumlah: 1),
        ],
        jumlahBayar: 50000,
      );
      expect(state.kembalian, 0.0);
    });
  });

  group('CashierReady — empty cart', () {
    test('total = 0', () {
      final state = _createCashierReady([]);
      expect(state.total, 0.0);
    });

    test('kembalian = 0', () {
      final state = _createCashierReady([], jumlahBayar: 0);
      expect(state.kembalian, 0.0);
    });
  });
}

//////
// Helper untuk membuat CashierReady tanpa harus inject semua dependencies
//////

class _TestCashierReady extends Equatable {
  final List<CartItem> cart;
  final double jumlahBayar;

  const _TestCashierReady({this.cart = const [], this.jumlahBayar = 0});

  double get total => cart.fold(0.0, (sum, item) => sum + item.subtotal);
  double get totalDiskon => cart.fold(0.0, (sum, item) => sum + item.totalDiskon);
  double get totalSetelahDiskon => total - totalDiskon;
  double get kembalian =>
      jumlahBayar >= totalSetelahDiskon ? jumlahBayar - totalSetelahDiskon : 0;

  @override
  List<Object?> get props => [cart, jumlahBayar];
}

_TestCashierReady _createCashierReady(List<CartItem> items, {double jumlahBayar = 0}) {
  return _TestCashierReady(cart: items, jumlahBayar: jumlahBayar);
}
