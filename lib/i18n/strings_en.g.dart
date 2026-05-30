///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Hend Kasir'
	String get app_name => 'Hend Kasir';

	late final Translations$login$en login = Translations$login$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$pin$en pin = Translations$pin$en._(_root);
	late final Translations$error$en error = Translations$error$en._(_root);
	late final Translations$dashboard$en dashboard = Translations$dashboard$en._(_root);
	late final Translations$quick_actions$en quick_actions = Translations$quick_actions$en._(_root);
	late final Translations$price_update$en price_update = Translations$price_update$en._(_root);
}

// Path: login
class Translations$login$en {
	Translations$login$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get title => 'Login';

	/// en: 'Email'
	String get email_hint => 'Email';

	/// en: 'Password'
	String get password_hint => 'Password';

	/// en: 'Masuk'
	String get login_btn => 'Masuk';

	/// en: 'Belum punya toko? Daftar'
	String get register_prompt => 'Belum punya toko? Daftar';
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Selamat datang,'
	String get welcome => 'Selamat datang,';

	/// en: 'Keluar'
	String get logout => 'Keluar';
}

// Path: pin
class Translations$pin$en {
	Translations$pin$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Masukkan PIN'
	String get title => 'Masukkan PIN';

	/// en: 'Buat PIN Baru'
	String get setup_title => 'Buat PIN Baru';

	/// en: 'Konfirmasi PIN'
	String get verify_title => 'Konfirmasi PIN';
}

// Path: error
class Translations$error$en {
	Translations$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Terjadi kesalahan yang tidak diketahui'
	String get unknown => 'Terjadi kesalahan yang tidak diketahui';

	/// en: 'Tidak ada koneksi internet'
	String get network => 'Tidak ada koneksi internet';

	/// en: 'Hanya owner yang bisa akses Laporan'
	String get owner_only_report => 'Hanya owner yang bisa akses Laporan';
}

// Path: dashboard
class Translations$dashboard$en {
	Translations$dashboard$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OMZET HARI INI'
	String get omzet_today => 'OMZET HARI INI';

	/// en: 'Transaksi'
	String get transaction => 'Transaksi';

	/// en: 'Terjual'
	String get sold => 'Terjual';

	/// en: 'Stok Menipis'
	String get low_stock => 'Stok Menipis';

	/// en: 'Lihat semua'
	String get see_all => 'Lihat semua';

	/// en: 'Sisa'
	String get remaining => 'Sisa';
}

// Path: quick_actions
class Translations$quick_actions$en {
	Translations$quick_actions$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Aksi Cepat'
	String get title => 'Aksi Cepat';

	/// en: 'KASIR'
	String get cashier => 'KASIR';

	/// en: 'LAPORAN'
	String get report => 'LAPORAN';

	/// en: 'PRODUK'
	String get product => 'PRODUK';

	/// en: 'TAMBAH'
	String get add => 'TAMBAH';
}

// Path: price_update
class Translations$price_update$en {
	Translations$price_update$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Update Harga Barang'
	String get title => 'Update Harga Barang';

	/// en: 'Produk Dihapus'
	String get product_deleted => 'Produk Dihapus';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app_name' => 'Hend Kasir',
			'login.title' => 'Login',
			'login.email_hint' => 'Email',
			'login.password_hint' => 'Password',
			'login.login_btn' => 'Masuk',
			'login.register_prompt' => 'Belum punya toko? Daftar',
			'home.welcome' => 'Selamat datang,',
			'home.logout' => 'Keluar',
			'pin.title' => 'Masukkan PIN',
			'pin.setup_title' => 'Buat PIN Baru',
			'pin.verify_title' => 'Konfirmasi PIN',
			'error.unknown' => 'Terjadi kesalahan yang tidak diketahui',
			'error.network' => 'Tidak ada koneksi internet',
			'error.owner_only_report' => 'Hanya owner yang bisa akses Laporan',
			'dashboard.omzet_today' => 'OMZET HARI INI',
			'dashboard.transaction' => 'Transaksi',
			'dashboard.sold' => 'Terjual',
			'dashboard.low_stock' => 'Stok Menipis',
			'dashboard.see_all' => 'Lihat semua',
			'dashboard.remaining' => 'Sisa',
			'quick_actions.title' => 'Aksi Cepat',
			'quick_actions.cashier' => 'KASIR',
			'quick_actions.report' => 'LAPORAN',
			'quick_actions.product' => 'PRODUK',
			'quick_actions.add' => 'TAMBAH',
			'price_update.title' => 'Update Harga Barang',
			'price_update.product_deleted' => 'Produk Dihapus',
			_ => null,
		};
	}
}
