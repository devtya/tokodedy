"""Fix broken .get() calls where regex removed where clause + closing paren."""
import os

BASE = r"D:\PROJECT\TOKO DEDY\tokodedy"
FILES = [
    "lib/data/repositories/produk_repository_impl.dart",
    "lib/data/repositories/pembelian_repository_impl.dart",
    "lib/data/repositories/transaksi_repository_impl.dart",
    "lib/data/repositories/laporan_repository_impl.dart",
    "lib/data/repositories/pending_pembelian_repository_impl.dart",
    "lib/data/repositories/pending_order_repository_impl.dart",
    "lib/data/repositories/hutang_piutang_repository_impl.dart",
    "lib/data/repositories/supplier_repository_impl.dart",
]

for relpath in FILES:
    path = os.path.join(BASE, relpath)
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    
    # Fix: (_db.select(...).get() -> _db.select(...).get()
    import re
    content = re.sub(r'\(_db\.select\(_db\.(\w+)\)\.get\(\)', r'_db.select(_db.\1).get()', content)
    
    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  Fixed: {relpath}")
    else:
        print(f"  No change: {relpath}")

print("Done!")
