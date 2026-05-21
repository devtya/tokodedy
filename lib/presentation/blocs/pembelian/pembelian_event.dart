import 'package:equatable/equatable.dart';

abstract class PembelianEvent extends Equatable {
  const PembelianEvent();
  @override
  List<Object?> get props => [];
}

class LoadPembelian extends PembelianEvent {}

class AddPembelianEvent extends PembelianEvent {
  final String namaSupplier;
  final String? supplierId;
  final List<ItemPembelianData> items;

  const AddPembelianEvent({
    required this.namaSupplier,
    this.supplierId,
    required this.items,
  });

  @override
  List<Object?> get props => [namaSupplier, supplierId, items];
}

class UpdatePembelianEvent extends PembelianEvent {
  final String pembelianId;
  final String namaSupplier;
  final List<ItemPembelianData> items;

  const UpdatePembelianEvent({
    required this.pembelianId,
    required this.namaSupplier,
    required this.items,
  });

  @override
  List<Object?> get props => [pembelianId, namaSupplier, items];
}

class ItemPembelianData {
  final String produkId;
  final String namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double subtotal;
  // null = satuan dasar, non-null = SatuanProduk.id
  final String? satuanId;
  // 1.0 = satuan dasar, >1.0 = satuan konversi (misal 1 karton = 10 pcs → konversi=10)
  final double konversi;

  const ItemPembelianData({
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.subtotal,
    this.satuanId,
    this.konversi = 1.0,
  });
}
