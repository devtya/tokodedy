import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class PinHashUtil {
  static const int _iterations = 100000;
  static const int _keyLength = 32;
  static const String _separator = ':';

  /// Generate a new salt (hex string)
  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Hash PIN with PBKDF2 — returns "salt:hash" string
  static String hashPin(String pin, String salt) {
    final saltBytes = _hexToBytes(salt);
    final pinBytes = utf8.encode(pin);
    final key = _pbkdf2(pinBytes, saltBytes, _iterations, _keyLength);
    final hashHex = key.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '$salt$_separator$hashHex';
  }

  /// Verify PIN against stored "salt:hash" string
  static bool verifyPin(String pin, String stored) {
    try {
      final parts = stored.split(_separator);
      if (parts.length != 2) return false;
      final salt = parts[0];
      final expected = hashPin(pin, salt);
      return expected == stored;
    } catch (_) {
      return false;
    }
  }

  /// Check if a stored hash is legacy SHA-256 (no separator)
  static bool isLegacyHash(String stored) {
    return !stored.contains(_separator);
  }

  static Uint8List _pbkdf2(
    List<int> password,
    List<int> salt,
    int iterations,
    int keyLength,
  ) {
    final hmac = Hmac(sha256, password);
    final blocks = (keyLength / 32).ceil();
    final result = <int>[];
    for (var i = 1; i <= blocks; i++) {
      final block = _f(hmac, salt, iterations, i);
      result.addAll(block);
    }
    return Uint8List.fromList(result.take(keyLength).toList());
  }

  static List<int> _f(
    Hmac hmac,
    List<int> salt,
    int iterations,
    int blockIndex,
  ) {
    final u = <List<int>>[];
    final saltWithIndex = [
      ...salt,
      (blockIndex >> 24) & 0xff,
      (blockIndex >> 16) & 0xff,
      (blockIndex >> 8) & 0xff,
      blockIndex & 0xff,
    ];
    u.add(hmac.convert(saltWithIndex).bytes);
    for (var i = 1; i < iterations; i++) {
      u.add(hmac.convert(u.last).bytes);
    }
    final xor = List<int>.from(u.first);
    for (var i = 1; i < u.length; i++) {
      for (var j = 0; j < xor.length; j++) {
        xor[j] ^= u[i][j];
      }
    }
    return xor;
  }

  static List<int> _hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return result;
  }
}
