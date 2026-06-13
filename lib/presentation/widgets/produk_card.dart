import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/produk.dart';



class ProdukCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback? onTap;
  final VoidCallback? onStockTap;
  final VoidCallback? onLogTap;

  const ProdukCard({
    super.key,
    required this.produk,
    this.onTap,
    this.onStockTap,
    this.onLogTap,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final stokMin = produk.stokMinimum ?? 0;
    final isLowStock = produk.stok <= stokMin;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (produk.imageUrl != null && produk.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    produk.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  ),
                )
              else
                _buildPlaceholder(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produk.nama,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: produk.isArchived ? AppTheme.neutralGrey : null,
                        decoration: produk.isArchived ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Column(
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 24),
    );
  }
}
