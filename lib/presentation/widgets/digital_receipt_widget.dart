import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/receipt_data.dart';

class DigitalReceiptWidget extends StatelessWidget {
  final ReceiptData receipt;
  final String statusTitle;

  const DigitalReceiptWidget({
    super.key,
    required this.receipt,
    this.statusTitle = 'Pembayaran Berhasil',
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    final total = receipt.subtotal - receipt.totalDiskon;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header / App Logo substitute
          Text(
            receipt.namaToko,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 24),
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Status
          Text(
            statusTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Grand Total
          Text(
            currency.format(total),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // Date & Ref
          Text(
            '${receipt.tanggal} WIB',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Ref ID: ${receipt.transaksiId}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 32),

          // Kasir Section
          if (receipt.kasir.isNotEmpty) ...[
            _buildSectionTitle('Kasir'),
            _buildRowText(receipt.kasir, ''),
            const SizedBox(height: 24),
          ],

          // Item List Section
          _buildSectionTitle('Daftar Item yang Dibeli'),
          ...receipt.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.jumlah} x ${currency.format(item.harga)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      currency.format((item.jumlah * item.harga) - item.diskon),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Detail Pembayaran Section
          _buildSectionTitle('Detail Pembayaran'),
          _buildDetailRow('Subtotal', currency.format(receipt.subtotal)),
          if (receipt.totalDiskon > 0)
            _buildDetailRow('Diskon', '-${currency.format(receipt.totalDiskon)}'),
          if (receipt.metodePembayaran.isNotEmpty) ...[
            _buildDetailRow('Metode Pembayaran', receipt.metodePembayaran),
            _buildDetailRow('Tunai/Dibayar', currency.format(receipt.totalBayar)),
            if (receipt.kembalian > 0)
              _buildDetailRow('Kembalian', currency.format(receipt.kembalian)),
          ],

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 1),
          const SizedBox(height: 16),

          // Final Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              Text(
                currency.format(total),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Footer
          const Text(
            'Terima kasih atas kunjungan Anda',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRowText(String title, String value) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
