import 'package:injectable/injectable.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../core/di/injection.dart';
import '../models/receipt_data.dart';
import 'printer_settings.dart';
import 'printing/esc_pos_builder.dart';

@lazySingleton
class BluetoothPrinterService {
  static const _channel = MethodChannel('tokodedy/bluetooth');

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  bool _isManuallyDisconnected = false;

  BluetoothPrinterService() {
    _initAdapterStateListener();
  }

  void _initAdapterStateListener() {
    FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        autoConnect();
      }
    });
  }

  String get printerType => 'bluetooth';

  static Future<List<Map<String, String>>> getBondedDevices() async {
    try {
      final result = await _channel.invokeListMethod<Map<dynamic, dynamic>>(
        'getBondedDevices',
      );
      if (result == null) return [];
      return result.map((m) => {
            'name': (m['name'] as String?) ?? '',
            'address': (m['address'] as String?) ?? '',
          }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<BluetoothDevice>> scanPrinters() async {
    final devices = <BluetoothDevice>[];

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        if (!devices.contains(result.device)) {
          devices.add(result.device);
        }
      }
    });

    await Future.delayed(const Duration(seconds: 6));
    await FlutterBluePlus.stopScan();
    return devices;
  }

  Future<bool> autoConnect() async {
    try {
      if (_isManuallyDisconnected) return false;

      final settings = sl<PrinterSettings>();
      if (!settings.enabled) {
        return false;
      }
      final address = settings.deviceAddress;
      if (address.isEmpty) {
        return false;
      }

      if (_device != null && _characteristic != null && _device!.remoteId.toString() == address) {
        final connected = _device!.isConnected;
        if (connected) return true;
      }

      final device = BluetoothDevice(remoteId: DeviceIdentifier(address));
      return await connect(device);
    } catch (e) {
      return false;
    }
  }

  Future<bool> connect(BluetoothDevice device) async {
    try {
      _isManuallyDisconnected = false;
      _device = device;
      await _device!.connect(timeout: const Duration(seconds: 10));

      final services = await _device!.discoverServices();
      for (final service in services) {
        for (final characteristic in service.characteristics) {
          if (characteristic.properties.write ||
              characteristic.properties.writeWithoutResponse) {
            _characteristic = characteristic;

            // Auto save device address
            try {
              final settings = sl<PrinterSettings>();
              if (settings.deviceAddress != device.remoteId.toString()) {
                settings.deviceAddress = device.remoteId.toString();
              }
            } catch (_) {}

            // Listen for disconnection to auto-reconnect
            _device!.connectionState.listen((state) {
              if (state == BluetoothConnectionState.disconnected) {
                _characteristic = null;
                // Try to reconnect after a short delay
                Future.delayed(const Duration(seconds: 5), () {
                  autoConnect();
                });
              }
            });

            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> disconnect() async {
    _isManuallyDisconnected = true;
    await _device?.disconnect();
    _device = null;
    _characteristic = null;
  }

  Future<bool> isConnected() async {
    if (_device == null) {
      final settings = sl<PrinterSettings>();
      if (settings.enabled && settings.deviceAddress.isNotEmpty) {
        return await autoConnect();
      }
      return false;
    }
    final connected = _device!.isConnected;
    if (!connected) {
      return await autoConnect();
    }
    return _characteristic != null;
  }

  Future<void> _writeBytes(List<int> bytes) async {
    if (_characteristic == null) {
      throw Exception('Printer tidak terhubung');
    }
    const chunkSize = 200;
    for (int i = 0; i < bytes.length; i += chunkSize) {
      final end = i + chunkSize < bytes.length ? i + chunkSize : bytes.length;
      final chunk = bytes.sublist(i, end);
      await _characteristic!.write(chunk, withoutResponse: false);
      await Future.delayed(const Duration(milliseconds: 20));
    }
  }

  Future<bool> testPrint() async {
    try {
      if (!await isConnected()) return false;
      await _writeBytes([0x1B, 0x40]);
      await _writeBytes(utf8.encode('Test Print - OK\n\n'));
      await _writeBytes([0x1D, 0x56, 0x41, 0x03]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> printReceipt(ReceiptData data) async {
    if (!await isConnected()) {
      throw Exception('Printer tidak terhubung');
    }
    final bytes = const EscPosBuilder().buildReceipt(data);
    for (int i = 0; i < bytes.length; i += 512) {
      final chunk = bytes.sublist(
        i,
        i + 512 > bytes.length ? bytes.length : i + 512,
      );
      await _writeBytes(chunk);
    }
    return true;
  }

  Future<bool> printPickingList(ReceiptData data) async {
    if (!await isConnected()) {
      throw Exception('Printer tidak terhubung');
    }
    final bytes = const EscPosBuilder().buildPickingList(data);
    for (int i = 0; i < bytes.length; i += 512) {
      final chunk = bytes.sublist(
        i,
        i + 512 > bytes.length ? bytes.length : i + 512,
      );
      await _writeBytes(chunk);
    }
    return true;
  }
}
