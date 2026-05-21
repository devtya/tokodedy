import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/receipt_data.dart';
import 'printer_service.dart';

class NetworkPrinterService implements PrinterService {
  final String baseUrl;

  NetworkPrinterService({required this.baseUrl});

  @override
  String get printerType => 'network';


  @override
  Future<bool> isConnected() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 3));
      final data = jsonDecode(response.body);
      return data['printer_connected'] == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> testPrint() async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/test-print'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> printReceipt(ReceiptData data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/print'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Gagal print');
      }
    } catch (e) {
      rethrow;
    }
  }
}
