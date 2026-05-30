import os

def insert_annotation(file_path, class_name, annotation):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if annotation in content:
        print(f"Already annotated: {file_path}")
        return

    # Add injectable import if not present
    if "import 'package:injectable/injectable.dart';" not in content:
        content = "import 'package:injectable/injectable.dart';\n" + content

    content = content.replace(f"class {class_name}", f"{annotation}\nclass {class_name}")

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Annotated {class_name} with {annotation} in {file_path}")

def main():
    base_dir = "lib"
    
    # TokoService
    insert_annotation(f"{base_dir}/core/services/toko_service.dart", "TokoService", "@lazySingleton")
    
    # UpdateService
    insert_annotation(f"{base_dir}/core/services/update_service.dart", "UpdateService", "@lazySingleton")
    
    # PrinterSettings
    insert_annotation(f"{base_dir}/data/services/printer_settings.dart", "PrinterSettings", "@lazySingleton")
    
    # BluetoothPrinterService
    insert_annotation(f"{base_dir}/data/services/bluetooth_printer_service.dart", "BluetoothPrinterService", "@lazySingleton")
    
    # SupplierProductsDao
    insert_annotation(f"{base_dir}/data/database/supplier_products_dao.dart", "SupplierProductsDao", "@lazySingleton")
    
    # ReceiptGenerator
    insert_annotation(f"{base_dir}/data/services/receipt_generator.dart", "ReceiptGenerator", "@injectable")

if __name__ == '__main__':
    main()
