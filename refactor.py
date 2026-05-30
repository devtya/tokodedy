import os
import re

DOMAIN_DIR = 'lib/domain/repositories'

def process_domain():
    for root, _, files in os.walk(DOMAIN_DIR):
        for file in files:
            if not file.endswith('.dart'):
                continue
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8') as f:
                content = f.read()

            if 'package:fpdart/fpdart.dart' not in content:
                content = "import 'package:fpdart/fpdart.dart';\nimport '../../core/errors/failure.dart';\n" + content
            
            # Match Future<Type> methodName(args);
            # We must be careful with nested generics like Future<List<User>>
            # A simple approach is finding "Future<" and replacing it up to the method name.
            # But let's use a regex carefully:
            # We want to replace `Future<T> name(` with `Future<Either<Failure, T>> name(`
            
            def replacer(match):
                ret_type = match.group(1)
                method_name = match.group(2)
                if ret_type.startswith('Either<'):
                    return match.group(0) # Already refactored
                return f"Future<Either<Failure, {ret_type}>> {method_name}("
            
            # Match Future<...something...> methodName(
            content = re.sub(r'Future<(.+?)>\s+([a-zA-Z0-9_]+)\(', replacer, content)
            
            with open(path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Updated {file}")

if __name__ == '__main__':
    process_domain()
