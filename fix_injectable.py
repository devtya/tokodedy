import os
import re

def fix_repositories():
    dir_path = 'lib/data/repositories'
    for file in os.listdir(dir_path):
        if not file.endswith('.dart'):
            continue
        path = os.path.join(dir_path, file)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()

        match = re.search(r'class (\w+Impl)\s+implements\s+(\w+)', content)
        if match:
            impl_name = match.group(1)
            interface_name = match.group(2)
            
            # ganti @lazySingleton dengan @LazySingleton(as: InterfaceName)
            content = content.replace('@lazySingleton', f'@LazySingleton(as: {interface_name})')
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Fixed {file} -> @LazySingleton(as: {interface_name})")

if __name__ == '__main__':
    fix_repositories()
