abstract class LocalAuthRepository {
  Future<bool> hasPin(String userId);
  Future<void> setPin(String userId, String pin);
  Future<bool> verifyPin(String userId, String pin);
  Future<void> removePin(String userId);

  Future<void> recordFailedAttempt(String userId);
  Future<void> resetAttempts(String userId);
  Future<int> getFailedAttempts(String userId);
  Future<DateTime?> getLockoutUntil(String userId);
  bool isLockedOut(DateTime? lockoutUntil);

  Future<bool> isBiometricAvailable();
  Future<bool> authenticateWithBiometrics();
  Future<void> enableBiometric(String userId);
  Future<void> disableBiometric(String userId);
  Future<bool> isBiometricEnabled(String userId);
}
