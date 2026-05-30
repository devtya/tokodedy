import os
import re

IMPL_DIR = 'lib/data/repositories'

def process_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'package:fpdart/fpdart.dart' not in content:
        imports = "import 'package:fpdart/fpdart.dart';\nimport '../../core/errors/failure.dart';\nimport '../../core/utils/run_guard.dart';\n"
        content = imports + content

    # Find all methods
    # Signature looks like: Future<Type> name(...) async {
    # We'll use regex to find the start.
    
    # But wait, they might have `@override\nFuture<...>`
    # We will search for `@override`
    # Then `Future<` or `Type name(`
    
    pattern = re.compile(r'(Future<([a-zA-Z0-9_\?<>]+)>)\s+([a-zA-Z0-9_]+)\s*\(([^)]*)\)\s*async\s*\{')
    
    out = ""
    idx = 0
    while True:
        match = pattern.search(content, idx)
        if not match:
            out += content[idx:]
            break
            
        out += content[idx:match.start()]
        
        full_match = match.group(0)
        ret_type = match.group(2)
        name = match.group(3)
        args = match.group(4)
        
        if ret_type.startswith('Either<'):
            out += full_match
            idx = match.end()
            continue
            
        # Refactor signature
        new_sig = f"Future<Either<Failure, {ret_type}>> {name}({args}) async {{"
        out += new_sig
        
        # Now find the matching closing brace
        start_idx = match.end()
        brace_count = 1
        curr_idx = start_idx
        while brace_count > 0 and curr_idx < len(content):
            if content[curr_idx] == '{':
                brace_count += 1
            elif content[curr_idx] == '}':
                brace_count -= 1
            curr_idx += 1
            
        end_idx = curr_idx - 1 # This is the closing brace '}'
        
        body = content[start_idx:end_idx]
        
        new_body = f"\n    return runGuard(() async {{{body}}});\n  "
        out += new_body + "}"
        
        idx = end_idx + 1

    # What about non-async methods? E.g., `Either<Failure, User?> getCurrentUser() {`
    # Let's do another pass for non-async methods returning a specific type, but it's risky.
    # It's better to manually fix non-async methods if there are compile errors.

    with open(path, 'w', encoding='utf-8') as f:
        f.write(out)

for root, _, files in os.walk(IMPL_DIR):
    for file in files:
        if file.endswith('_impl.dart'):
            process_file(os.path.join(root, file))

print("Done parsing implementations")
