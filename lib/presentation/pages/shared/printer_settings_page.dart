// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/bluetooth_printer_service.dart';
import '../../../data/services/printer_service.dart';
import '../../../data/services/printer_settings.dart';
import '../../../data/services/network_printer_service.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  late PrinterSettings _settings;
  PrinterService? _printerService;
  BluetoothPrinterService? _btService;

  final _urlController = TextEditingController();
  final _namaTokoController = TextEditingController();
  final _alamatTokoController = TextEditingController();

  bool _isLoading = false;
  String _status = '';
  bool _printerConnected = false;

  // Bluetooth state
  List<BluetoothDevice> _btDevices = [];
  List<Map<String, String>> _bondedDevices = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _settings = sl<PrinterSettings>();
    _initService();
    _urlController.text = _settings.url;
    _namaTokoController.text = _settings.namaToko;
    _alamatTokoController.text = _settings.alamatToko;
    _checkConnection();
  }

  void _initService() {
    if (_settings.type == 'bluetooth') {
      _btService = sl<BluetoothPrinterService>();
      _printerService = _btService;
    } else {
      _printerService = NetworkPrinterService(baseUrl: _settings.url);
      _btService = null;
    }
  }

  Future<bool> _requestBluetoothPermissions() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        final statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ].request();
        return statuses.values.every((s) => s.isGranted);
      } else {
        final status = await Permission.location.request();
        return status.isGranted;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _checkConnection() async {
    setState(() => _isLoading = true);
    try {
      _printerConnected = await _printerService!.isConnected();
      _status = _printerConnected ? 'Printer terhubung' : 'Printer tidak terhubung';
    } catch (e) {
      _status = 'Error: $e';
      _printerConnected = false;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _testPrint() async {
    setState(() => _isLoading = true);
    try {
      final success = await _printerService!.testPrint();
      _status = success ? 'Test print berhasil!' : 'Test print gagal';
    } catch (e) {
      _status = 'Error: $e';
    }
    setState(() => _isLoading = false);
  }

  Future<void> _scanBluetooth() async {
    if (_btService == null) return;

    final granted = await _requestBluetoothPermissions();
    if (!granted) {
      setState(() {
        _status = 'Izin Bluetooth ditolak. Buka Settings > Aplikasi > Kasir > Izinkan Bluetooth.';
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _btDevices = [];
      _bondedDevices = [];
    });
    try {
      final results = await Future.wait([
        _btService!.scanPrinters(),
        BluetoothPrinterService.getBondedDevices(),
      ]);
      final devices = results[0] as List<BluetoothDevice>;
      final bonded = results[1] as List<Map<String, String>>;
      setState(() {
        _btDevices = devices;
        _bondedDevices = bonded;
      });
      final total = devices.length + bonded.length;
      if (total == 0) {
        _status = 'Tidak ditemukan printer Bluetooth';
      } else {
        _status = 'Ditemukan $total printer (${devices.length} BLE, ${bonded.length} terpasang)';
      }
    } catch (e) {
      _status = 'Scan gagal: $e';
    }
    setState(() => _isScanning = false);
  }

  Future<void> _connectBluetooth(BluetoothDevice device) async {
    if (_btService == null) return;
    setState(() => _isLoading = true);
    try {
      final success = await _btService!.connect(device);
      if (success) {
        _settings.enabled = true;
        updatePrinterService();
        _status = 'Terhubung ke ${device.platformName}';
        _printerConnected = true;
      } else {
        _status = 'Gagal connect ke ${device.platformName}';
        _printerConnected = false;
      }
    } catch (e) {
      _status = 'Error: $e';
      _printerConnected = false;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _disconnectBluetooth() async {
    if (_btService == null) return;
    setState(() => _isLoading = true);
    try {
      await _btService!.disconnect();
      _status = 'Terputus';
      _printerConnected = false;
    } catch (e) {
      _status = 'Error: $e';
    }
    setState(() => _isLoading = false);
  }

  Future<void> _connectBondedDevice(String name, String address) async {
    if (_btService == null) return;
    setState(() => _isLoading = true);
    try {
      final device = BluetoothDevice(
        remoteId: DeviceIdentifier(address),
      );
      final success = await _btService!.connect(device);
      if (success) {
        _settings.enabled = true;
        updatePrinterService();
        _status = 'Terhubung ke $name';
        _printerConnected = true;
      } else {
        _status = 'Gagal connect ke $name. Periksa apakah printer mendukung BLE.';
        _printerConnected = false;
      }
    } catch (e) {
      _status = 'Error: $e';
      _printerConnected = false;
    }
    setState(() => _isLoading = false);
  }

  void _switchType(String type) {
    setState(() {
      _settings.type = type;
      _initService();
      _status = '';
      _printerConnected = false;
      _btDevices = [];
    });
  }

  void _setFontSize(String? value) {
    if (value != null) setState(() => _settings.fontSize = value);
  }

  void _saveSettings() {
    _settings.url = _urlController.text;
    _settings.namaToko = _namaTokoController.text;
    _settings.alamatToko = _alamatTokoController.text;
    _initService();
    updatePrinterService();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan disimpan')),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _namaTokoController.dispose();
    _alamatTokoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Printer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Toggle aktif
          Card(
            child: SwitchListTile(
              title: const Text('Aktifkan Printer'),
              subtitle: const Text('Print otomatis setelah transaksi'),
              value: _settings.enabled,
              onChanged: (v) {
                setState(() => _settings.enabled = v);
              },
            ),
          ),
          const SizedBox(height: 12),

          // Auto print
          Card(
            child: SwitchListTile(
              title: const Text('Auto Print'),
              subtitle: const Text('Langsung print tanpa konfirmasi'),
              value: _settings.autoPrint,
              onChanged: (v) {
                setState(() => _settings.autoPrint = v);
              },
            ),
          ),
          const SizedBox(height: 12),

          // Tipe Printer
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TIPE PRINTER',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.neutralGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Network (HTTP)'),
                    subtitle: const Text('via print_server.py'),
                    value: 'network',
                    groupValue: _settings.type,
                    onChanged: (v) => _switchType(v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Bluetooth'),
                    subtitle: const Text('Langsung ke printer'),
                    value: 'bluetooth',
                    groupValue: _settings.type,
                    onChanged: (v) => _switchType(v!),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Network settings (hanya untuk tipe network)
          if (_settings.type == 'network') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ALAMAT PRINT SERVER',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.neutralGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'http://192.168.1.100:5000',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.dns),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'IP PC yang menjalankan print_server.py',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.neutralGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Bluetooth settings (hanya untuk tipe bluetooth)
          if (_settings.type == 'bluetooth') ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRINTER BLUETOOTH',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.neutralGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isScanning ? null : _scanBluetooth,
                        icon: _isScanning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.bluetooth_searching),
                        label: Text(
                            _isScanning ? 'Memindai...' : 'Cari Printer Bluetooth'),
                      ),
                    ),
                    if (_btDevices.isNotEmpty || _bondedDevices.isNotEmpty) ...[
                      const SizedBox(height: 12),
                    ],
                    if (_btDevices.isNotEmpty) ...[
                      const Text(
                        'Printer BLE ditemukan:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      ..._btDevices.map(
                        (d) => Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.bluetooth),
                            title: Text(d.platformName.isNotEmpty
                                ? d.platformName
                                : d.remoteId.toString()),
                            subtitle: Text(d.remoteId.toString()),
                            trailing: ElevatedButton(
                              onPressed: () => _connectBluetooth(d),
                              child: const Text('Hubungkan'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_bondedDevices.isNotEmpty) ...[
                      if (_btDevices.isNotEmpty)
                        const SizedBox(height: 8),
                      const Text(
                        'Terpasang di sistem:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      ..._bondedDevices.map(
                        (d) => Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            dense: true,
                            leading: const Icon(Icons.bluetooth_connected),
                            title: Text(
                                d['name']?.isNotEmpty == true ? d['name']! : d['address']!),
                            subtitle: Text(d['address'] ?? ''),
                            trailing: ElevatedButton(
                              onPressed: () => _connectBondedDevice(
                                d['name'] ?? '',
                                d['address'] ?? '',
                              ),
                              child: const Text('Hubungkan'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (_printerConnected) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _disconnectBluetooth,
                          icon: const Icon(Icons.bluetooth_disabled),
                          label: const Text('Putuskan Koneksi'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.warningRed,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Lebar kertas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LEBAR KERTAS',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.neutralGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<int>(
                    title: const Text('58 mm'),
                    value: 58,
                    groupValue: _settings.lebarKertas,
                    onChanged: (v) {
                      setState(() => _settings.lebarKertas = v!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('80 mm'),
                    value: 80,
                    groupValue: _settings.lebarKertas,
                    onChanged: (v) {
                      setState(() => _settings.lebarKertas = v!);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Ukuran Font
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UKURAN FONT',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.neutralGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Kecil'),
                    value: 'kecil',
                    groupValue: _settings.fontSize,
                    onChanged: _setFontSize,
                  ),
                  RadioListTile<String>(
                    title: const Text('Normal'),
                    value: 'normal',
                    groupValue: _settings.fontSize,
                    onChanged: _setFontSize,
                  ),
                  RadioListTile<String>(
                    title: const Text('Besar'),
                    value: 'besar',
                    groupValue: _settings.fontSize,
                    onChanged: _setFontSize,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Nama & Alamat Toko
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INFO TOKO (UNTUK NOTA)',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.neutralGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _namaTokoController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Toko',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _alamatTokoController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Toko (opsional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Status & Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'STATUS',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.neutralGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _printerConnected
                            ? Icons.check_circle
                            : Icons.error_outline,
                        color: _printerConnected
                            ? AppTheme.primaryGreen
                            : AppTheme.warningRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _status,
                          style: TextStyle(
                            color: _printerConnected
                                ? AppTheme.primaryGreen
                                : AppTheme.warningRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _checkConnection,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 18),
                          label: const Text('Cek Koneksi'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _testPrint,
                          icon: const Icon(Icons.print, size: 18),
                          label: const Text('Test Print'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Simpan Pengaturan'),
            ),
          ),
        ],
      ),
    );
  }
}
