import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/produk.dart';

import '../../core/di/injection.dart';
import '../../core/services/toko_service.dart';

class ProdukCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onTap;
  final VoidCallback? onStockTap;
  final VoidCallback? onDelete;
  final VoidCallback? onLogTap;

  const ProdukCard({
    super.key,
    required this.produk,
    this.onTap,
    this.onStockTap,
    this.onDelete,
    this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final stokMin = produk.stokMinimum ?? sl<TokoService>().stokMinimumGlobal;
    final isLowStock = produk.stok <= stokMin;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produk.nama,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Modal: ${currency.format(produk.hargaBeli)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.neutralGrey,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currency.format(produk.hargaJual),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isLowStock
                                  ? AppTheme.warningOrange.withValues(alpha: 0.15)
                                  : AppTheme.lightGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Stok: ${produk.stok}',
                              style: TextStyle(
                                color: isLowStock
                                    ? AppTheme.warningOrange
                                    : AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          if (produk.satuan != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text(
                                '/ ${produk.satuan}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.neutralGrey,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.qr_code,
                        size: 18,
                        color: produk.barcode != null
                            ? AppTheme.primaryGreen
                            : AppTheme.neutralGrey.withValues(alpha: 0.3),
                      ),
                      if (onStockTap != null)
                        IconButton(
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          color: AppTheme.primaryGreen,
                          onPressed: onStockTap,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      if (onLogTap != null)
                        IconButton(
                          icon: const Icon(Icons.info_outline, size: 18),
                          color: AppTheme.neutralGrey,
                          onPressed: onLogTap,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          color: AppTheme.warningRed,
                          onPressed: onDelete,
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
