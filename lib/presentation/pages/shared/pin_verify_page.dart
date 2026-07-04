import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/local_auth/local_auth_bloc.dart';
import '../../blocs/local_auth/local_auth_event.dart';
import '../../blocs/local_auth/local_auth_state.dart';
import '../../../i18n/strings.g.dart';
import '../../../presentation/widgets/pin_numpad.dart';

class PinVerifyPage extends StatefulWidget {
  final String userId;
  final VoidCallback onVerified;
  final VoidCallback onSkip;

  const PinVerifyPage({
    super.key,
    required this.userId,
    required this.onVerified,
    required this.onSkip,
  });

  @override
  State<PinVerifyPage> createState() => _PinVerifyPageState();
}

class _PinVerifyPageState extends State<PinVerifyPage> {
  String _pin = '';
  String _error = '';
  bool _hasAutoTriggered = false;
  int _pinLength = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<LocalAuthBloc>().state;
      if (state is PinReady && state.biometricEnabled && !_hasAutoTriggered) {
        _hasAutoTriggered = true;
        _biometricLogin();
      }
      if (state is PinReady) {
        _pinLength = state.pinLength;
      }
    });
  }

  void _verify() {
    final pin = _pin.trim();
    if (pin.isEmpty) {
      setState(() => _error = 'Masukkan PIN');
      return;
    }
    context.read<LocalAuthBloc>().add(VerifyPinEvent(widget.userId, pin));
  }

  void _biometricLogin() {
    context.read<LocalAuthBloc>().add(BiometricLoginEvent(widget.userId));
  }

  void _onDigit(String digit) {
    if (_pin.length >= _pinLength) return;
    setState(() {
      _pin += digit;
      _error = '';
      if (_pin.length == _pinLength) _verify();
    });
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.background : AppTheme.lightBackground,
      body: SafeArea(
        child: BlocConsumer<LocalAuthBloc, LocalAuthState>(
          listener: (context, state) {
            if (state is PinVerified) {
              widget.onVerified();
            } else if (state is PinError) {
              setState(() {
                _error = state.message;
                _pin = '';
              });
            } else if (state is PinReady) {
              _pinLength = state.pinLength;
              if (state.isLockedOut) {
                setState(() =>
                    _error = 'Terlalu banyak percobaan. Tunggu 30 detik.');
              }
              if (state.biometricEnabled && !_hasAutoTriggered) {
                _hasAutoTriggered = true;
                _biometricLogin();
              }
            } else if (state is PinNotSet) {
              widget.onSkip();
            }
          },
          builder: (context, state) {
            if (state is LocalAuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final isLocked = state is PinReady && state.isLockedOut;
            final bioAvail = state is PinReady && state.biometricAvailable;
            final curPinLength = state is PinReady ? state.pinLength : _pinLength;

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 64,
                              color: isDark ? AppTheme.primary : AppTheme.primary,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              t.pin.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.white : AppTheme.lightText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              t.pin.verify_title,
                              style: TextStyle(
                                color: isDark ? AppTheme.neutralGrey : AppTheme.lightTextSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 32),
                            PinDots(
                              digitCount: _pin.length,
                              totalDigits: curPinLength,
                              isError: _error.isNotEmpty,
                            ),
                            if (_error.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _error,
                                  style: const TextStyle(
                                    color: AppTheme.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed:
                                    (isLocked || _pin.isEmpty) ? null : _verify,
                                child: const Text(
                                  'VERIFIKASI',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (bioAvail) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed:
                                      isLocked ? null : _biometricLogin,
                                  icon: const Icon(Icons.fingerprint),
                                  label: const Text('Gunakan Sidik Jari'),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: widget.onSkip,
                              child: Text(
                                'Login dengan Password',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppTheme.primary : AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                PinNumpad(
                  enabled: !isLocked,
                  onDigit: _onDigit,
                  onBackspace: _onBackspace,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
