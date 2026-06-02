"""Fix misc syntax issues left after regex refactoring."""
import os, re

BASE = r"D:\PROJECT\TOKO DEDY\tokodedy"

# ── Fix & _db.) in pembelian, transaksi ──
files_to_fix = [
    "lib/data/repositories/pembelian_repository_impl.dart",
    "lib/data/repositories/transaksi_repository_impl.dart",
]
for relpath in files_to_fix:
    path = os.path.join(BASE, relpath)
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    content = content.replace('& _db.)', ')')
    content = content.replace('& _db.;', ';')
    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  Fixed: {relpath}")

# ── Fix lone & in laporan_repository_impl ──
path = os.path.join(BASE, "lib/data/repositories/laporan_repository_impl.dart")
if os.path.exists(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    orig = content
    # Find and replace lines that are just '          &' (whitespace + single &)
    content = re.sub(r'^\s+&\s*\n', '', content, flags=re.MULTILINE)
    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  Fixed: lib/data/repositories/laporan_repository_impl.dart")

print("Done!")
