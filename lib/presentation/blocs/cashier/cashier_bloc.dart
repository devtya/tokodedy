import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/produk/get_all_produk.dart';
import '../../../domain/usecases/produk/get_produk_by_barcode.dart';
import '../../../domain/usecases/produk/get_produk_by_id.dart';
import '../../../domain/usecases/transaksi/buat_transaksi.dart';
import 'cashier_event.dart';
import 'cashier_state.dart';

@injectable
class CashierBloc extends Bloc<CashierEvent, CashierState> {
  final GetAllProduk getAllProduk;
  final GetProdukByBarcode getProdukByBarcode;
  final BuatTransaksi buatTransaksi;
  final GetProdukById getProdukById;

  CashierBloc({
    required this.getAllProduk,
    required this.getProdukByBarcode,
    required this.buatTransaksi,
    required this.getProdukById,
  }) : super(CashierInitial()) {
    on<InitCashier>(_onInit);
    on<ScanBarcodeCashier>(_onScan);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateJumlahCart>(_onUpdateJumlah);
    on<UpdateJumlahBayar>(_onUpdateBayar);
    on<SetDiskonItem>(_onSetDiskon);
    on<LoadCartFromPending>(_onLoadPending);
    on<BayarCashier>(_onBayar);
    on<BayarHutangCashier>(_onBayarHutang);
    on<ClearError>(_onClearError);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onInit(InitCashier event, Emitter<CashierState> emit) async {
    emit(const CashierReady());
  }

  Future<void> _onScan(
    ScanBarcodeCashier event,
    Emitter<CashierState> emit,
  ) async {
    final produk = await getProdukByBarcode(event.barcode);
    if (produk == null) {
      final cart = state is CashierReady ? (state as CashierReady).cart : <CartItem>[];
      final jumlahBayar = state is CashierReady ? (state as CashierReady).jumlahBayar : 0.0;
      final currentReadyState = state is CashierReady 
          ? (state as CashierReady) 
          : CashierReady(cart: cart, jumlahBayar: jumlahBayar);
      emit(CashierError(
        'Produk dengan barcode ${event.barcode} tidak ditemukan',
        cart: cart,
        jumlahBayar: jumlahBayar,
      ));
      emit(currentReadyState);
      return;
    }
    if (state is CashierReady) {
      add(
        AddToCart(
          produkId: produk.id!,
          namaProduk: '${produk.nama} - ${produk.satuan}',
          hargaJual: produk.hargaJual,
          hargaPokok: produk.hargaBeli,
          satuan: produk.satuan,
          konversi: 1.0,
        ),
      );
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CashierState> emit) async {
    // Skip stock validation for manual items
    if (!event.isManual) {
      final produk = await getProdukById(event.produkId);

      // Read the LATEST state after the await
      if (state is! CashierReady) return;
      final current = state as CashierReady;

      if (produk != null) {
        final cart = List<CartItem>.from(current.cart);
        // Stock is shared at base-unit level across all satuan variants of this
        // product, so sum every existing line with the same produkId.
        int existingBaseQty = 0;
        for (final item in cart) {
          if (item.produkId == event.produkId) {
            existingBaseQty += (item.jumlah * item.konversi).round();
          }
        }

        final newBaseQty = (event.jumlah * event.konversi).round();
        final totalNewBaseQty = existingBaseQty + newBaseQty;

        if (totalNewBaseQty > produk.stok) {
          emit(CashierError(
            'Stok ${produk.nama} tidak mencukupi. Sisa stok: ${produk.stok} pcs.',
            cart: current.cart,
            jumlahBayar: current.jumlahBayar,
          ));
          emit(current);
          return;
        }
      }
    }

    if (state is! CashierReady) return;
    final current = state as CashierReady;

    final cart = List<CartItem>.from(current.cart);
    // Merge only when the SAME product AND the SAME satuan (unit) is added
    // again. Different satuan variants of one product are distinct cart lines.
    // Manual items are never merged (each is its own line).
    int highlightIdx;
    if (!event.isManual) {
      final existingIndex = cart.indexWhere(
        (item) => item.produkId == event.produkId && item.satuan == event.satuan,
      );
      if (existingIndex >= 0) {
        final existing = cart[existingIndex];
        cart[existingIndex] = existing.copyWith(
          jumlah: existing.jumlah + event.jumlah,
        );
        highlightIdx = existingIndex;
      } else {
        cart.insert(0,
          CartItem(
            produkId: event.produkId,
            namaProduk: event.namaProduk,
            hargaJual: event.hargaJual,
            hargaPokok: event.hargaPokok,
            jumlah: event.jumlah,
            satuan: event.satuan,
            konversi: event.konversi,
            isManual: event.isManual,
            catatanManual: event.catatanManual,
          ),
        );
        highlightIdx = 0;
      }
    } else {
      cart.insert(0,
        CartItem(
          produkId: event.produkId,
          namaProduk: event.namaProduk,
          hargaJual: event.hargaJual,
          hargaPokok: 0,
          jumlah: event.jumlah,
          satuan: event.satuan,
          konversi: 1.0,
          isManual: true,
          catatanManual: event.catatanManual,
        ),
      );
      highlightIdx = 0;
    }
    emit(current.copyWith(cart: cart, highlightedIndex: highlightIdx));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CashierState> emit) {
    if (state is! CashierReady) return;
    final current = state as CashierReady;
    final cart = List<CartItem>.from(current.cart)..removeAt(event.index);
    emit(current.copyWith(cart: cart, clearHighlight: true));
  }

  Future<void> _onUpdateJumlah(UpdateJumlahCart event, Emitter<CashierState> emit) async {
    if (state is! CashierReady) return;
    var current = state as CashierReady;
    
    if (event.index < 0 || event.index >= current.cart.length) return;
    final item = current.cart[event.index];

    final produk = await getProdukById(item.produkId);
    
    // Re-read state after await
    if (state is! CashierReady) return;
    current = state as CashierReady;
    
    final cart = List<CartItem>.from(current.cart);
    if (event.index < 0 || event.index >= cart.length) return;

    if (event.jumlah <= 0) {
      cart.removeAt(event.index);
      emit(current.copyWith(cart: cart, clearHighlight: true));
      return;
    }

    // Skip stock validation for manual items
    if (!item.isManual && produk != null) {
      final totalNewBaseQty = (event.jumlah * item.konversi).round();
      if (totalNewBaseQty > produk.stok) {
        emit(CashierError(
          'Stok ${produk.nama} tidak mencukupi. Sisa stok: ${produk.stok} pcs.',
          cart: current.cart,
          jumlahBayar: current.jumlahBayar,
        ));
        emit(current);
        return;
      }
    }

    cart[event.index] = cart[event.index].copyWith(jumlah: event.jumlah);
    emit(current.copyWith(cart: cart, clearHighlight: true));
  }

  void _onUpdateBayar(UpdateJumlahBayar event, Emitter<CashierState> emit) {
    if (state is! CashierReady) return;
    final current = state as CashierReady;
    emit(current.copyWith(jumlahBayar: event.jumlah, clearHighlight: true));
  }

  void _onSetDiskon(SetDiskonItem event, Emitter<CashierState> emit) {
    if (state is! CashierReady) return;
    final current = state as CashierReady;
    final cart = List<CartItem>.from(current.cart);
    if (event.index < cart.length) {
      cart[event.index] = cart[event.index].copyWith(
        diskonTipe: event.tipe,
        diskonValue: event.value,
      );
    }
    emit(current.copyWith(cart: cart, clearHighlight: true));
  }

  void _onLoadPending(LoadCartFromPending event, Emitter<CashierState> emit) {
    final items = event.items;
    emit(const CashierReady());
    for (final item in items) {
      add(
        AddToCart(
          produkId: item.produkId,
          namaProduk: item.namaProduk,
          hargaJual: item.hargaJual,
          jumlah: item.jumlah,
          satuan: item.satuan,
          konversi: item.konversi,
        ),
      );
    }
    // Re-apply discounts after adding all items
    if (state is CashierReady) {
      var current = state as CashierReady;
      var cart = List<CartItem>.from(current.cart);
      for (var i = 0; i < items.length && i < cart.length; i++) {
        if (items[i].diskonTipe != 0) {
          cart[i] = cart[i].copyWith(
            diskonTipe: items[i].diskonTipe,
            diskonValue: items[i].diskonValue,
          );
        }
      }
      emit(current.copyWith(cart: cart, clearHighlight: true));
    }
  }

  Future<void> _onBayar(BayarCashier event, Emitter<CashierState> emit) async {
    if (state is! CashierReady) return;
    final current = state as CashierReady;
    if (current.cart.isEmpty) return;
    if (current.jumlahBayar < current.totalSetelahDiskon) {
      emit(CashierError(
        'Jumlah bayar kurang dari total',
        cart: current.cart,
        jumlahBayar: current.jumlahBayar,
      ));
      return;
    }
    try {
      emit(CashierLoading());
      final id = await buatTransaksi(
        cartItems: current.cart,
        jumlahBayar: current.jumlahBayar,
      );
      emit(CashierSuccess(id));
    } catch (e) {
      emit(CashierError(
        e.toString(),
        cart: current.cart,
        jumlahBayar: current.jumlahBayar,
      ));
    }
  }

  Future<void> _onBayarHutang(
    BayarHutangCashier event,
    Emitter<CashierState> emit,
  ) async {
    if (state is! CashierReady) return;
    final current = state as CashierReady;
    if (current.cart.isEmpty) return;
    if (event.namaPelanggan.trim().isEmpty) {
      emit(CashierError(
        'Nama pelanggan wajib diisi',
        cart: current.cart,
        jumlahBayar: current.jumlahBayar,
      ));
      return;
    }
    try {
      emit(CashierLoading());
      final id = await buatTransaksi(
        cartItems: current.cart,
        jumlahBayar: 0,
        namaPelanggan: event.namaPelanggan.trim(),
      );
      emit(CashierSuccess(id, isHutang: true));
    } catch (e) {
      emit(CashierError(
        e.toString(),
        cart: current.cart,
        jumlahBayar: current.jumlahBayar,
      ));
    }
  }

  void _onClearError(ClearError event, Emitter<CashierState> emit) {
    if (state is CashierError) {
      final error = state as CashierError;
      emit(CashierReady(
        cart: error.cart, 
        jumlahBayar: error.jumlahBayar,
        highlightedIndex: error.highlightedIndex,
      ));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CashierState> emit) {
    if (state is CashierReady) {
      final current = state as CashierReady;
      emit(current.copyWith(cart: const [], clearHighlight: true));
    }
  }
}
