import os
import re

USECASE_DIR = 'lib/domain/usecases'

def process_usecases():
    for root, _, files in os.walk(USECASE_DIR):
        for file in files:
            if not file.endswith('.dart'):
                continue
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            if 'package:fpdart/fpdart.dart' not in content:
                content = "import 'package:fpdart/fpdart.dart';\nimport '../../core/errors/failure.dart';\n" + content
            
            def replacer(match):
                ret_type = match.group(1)
                if ret_type.startswith('Either<'):
                    return match.group(0) # Already refactored
                return f"Future<Either<Failure, {ret_type}>> call("
            
            # Match Future<Type> call(
            # Because usecases usually have a `call` method.
            content = re.sub(r'Future<(.+?)>\s+call\(', replacer, content)
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Updated {file}")

if __name__ == '__main__':
    process_usecases()
