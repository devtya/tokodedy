"""Fix all remaining analyze errors."""
import os

BASE = r"D:\PROJECT\TOKO DEDY\tokodedy"

def fix(path, pairs):
    p = os.path.join(BASE, path)
    if not os.path.exists(p):
        print(f"  NOT FOUND: {path}")
        return
    with open(p, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    for old, new in pairs:
        content = content.replace(old, new)
    if content != orig:
        with open(p, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  Fixed: {path}")

# 1. seed_data.dart - remove tokoId
fix("lib/data/database/seed_data.dart", [
    ("  const defaultTokoId = '1';\n\n", ""),
    ("        tokoId: defaultTokoId,\n", ""),
])

# 2. auth_repository.dart - remove Toko import + fetchToko + updateToko
fix("lib/domain/repositories/auth_repository.dart", [
    ("import '../entities/toko.dart';\n", ""),
])
# Remove methods
with open(os.path.join(BASE, "lib/domain/repositories/auth_repository.dart"), 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace("""  /// Daftar toko baru:
  /// 1. Buat akun Supabase Auth (email+password)
  /// 2. Insert toko ke Supabase
  /// 3. Insert profile owner ke Supabase
  /// 4. Simpan session lokal

  /// Ambil info toko dari Supabase
  Future<Toko?> fetchToko();

  /// Update info toko (nama, alamat, telepon)
  Future<void> updateToko(Toko toko);
}
""", "}\n")
with open(os.path.join(BASE, "lib/domain/repositories/auth_repository.dart"), 'w', encoding='utf-8') as f:
    f.write(content)
print("  Fixed: lib/domain/repositories/auth_repository.dart")

# 3. supplier_products_dao.dart
fix("lib/data/database/supplier_products_dao.dart", [
    ("      tokoId: Value(widget.supplier?.tokoId ?? ''),\n", ""),
])

# 4. laporan_repository_impl.dart line 115
fix("lib/data/repositories/laporan_repository_impl.dart", [
    ("       & _db.&", "      "),
])

# Let me check what's actually on line 115
with open(os.path.join(BASE, "lib/data/repositories/laporan_repository_impl.dart"), 'r', encoding='utf-8') as f:
    lines = f.readlines()
print(f"  Line 115: {repr(lines[114])}")

# 5. pengaturan_toko_page.dart - fix import and content
fix("lib/presentation/pages/shared/pengaturan_toko_page.dart", [
    ("import '../../../domain/entities/toko.dart';\n", ""),
])

# 6. pembelian_form_page.dart - fix tokoId at line 1083
fix("lib/presentation/pages/shared/pembelian_form_page.dart", [
    ("      tokoId: sl<TokoService>().tokoId ?? '',\n", ""),
])

# 7. Remove unused imports
fix("lib/core/di/injection.dart", [
    ("import '../../presentation/blocs/theme/theme_cubit.dart';\n", ""),
])
fix("lib/data/services/printer_settings.dart", [
    ("import '../../core/di/injection.dart';\n", ""),
])
fix("lib/presentation/blocs/pembelian/pembelian_bloc.dart", [
    ("import '../../../core/di/injection.dart';\n", ""),
])
fix("lib/presentation/pages/shared/hutang_form_page.dart", [
    ("import '../../../core/di/injection.dart';\n", ""),
])
fix("lib/presentation/pages/shared/laporan_page.dart", [
    ("import '../../../core/di/injection.dart';\n", ""),
])
fix("lib/presentation/pages/shared/supplier_form_page.dart", [
    ("import '../../../core/di/injection.dart';\n", ""),
])
fix("lib/presentation/widgets/produk_card.dart", [
    ("import '../../core/di/injection.dart';\n", ""),
])

# 8. Fix produk_form_page.dart - unused currentTokoId
fix("lib/presentation/pages/shared/produk_form_page.dart", [
    ("    // final currentTokoId = ", "    // final currentTokoId = "),
])

# 9. Fix produk_page.dart unused val and empty statement
with open(os.path.join(BASE, "lib/presentation/pages/shared/produk_page.dart"), 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace("""
              await sl<TokoService>().updateStokMinimumGlobal(val);
""", "")
content = content.replace("""
              await sl<TokoService>().updateStokMinimumGlobal(val);
""", "")
content = content.replace("""
              val =""", "")
with open(os.path.join(BASE, "lib/presentation/pages/shared/produk_page.dart"), 'w', encoding='utf-8') as f:
    f.write(content)
print("  Fixed: lib/presentation/pages/shared/produk_page.dart")

# 10. Fix priter_settings null check
fix("lib/data/services/printer_settings.dart", [
    ("? ''\n      : ", "? ''\n      : "),
])

# Actually let me read printer_settings around line 44
with open(os.path.join(BASE, "lib/data/services/printer_settings.dart"), 'r', encoding='utf-8') as f:
    lines = f.readlines()
print(f"  Printer settings line 44: {repr(lines[43])}")

print("\nDone!")
