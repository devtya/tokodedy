import os
import re

def add_annotation(directory, annotation):
    for root, _, files in os.walk(directory):
        for file in files:
            if not file.endswith('.dart'):
                continue
            if 'event' in file or 'state' in file or 'failure' in file:
                continue

            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            if 'injectable/injectable.dart' in content:
                continue # Already annotated

            # find class declaration
            match = re.search(r'^class (\w+)\s+(extends|implements)?', content, re.MULTILINE)
            if match:
                # Add import at top
                content = "import 'package:injectable/injectable.dart';\n" + content
                
                # Replace class with @annotation class
                class_str = match.group(0)
                content = content.replace(class_str, f"@{annotation}\n" + class_str)

                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Annotated {file} with @{annotation}")

if __name__ == '__main__':
    add_annotation('lib/data/repositories', 'lazySingleton')
    add_annotation('lib/domain/usecases', 'lazySingleton')
    add_annotation('lib/presentation/blocs', 'injectable')
