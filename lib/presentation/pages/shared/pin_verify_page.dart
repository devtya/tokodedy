import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/local_auth/local_auth_bloc.dart';
import '../../blocs/local_auth/local_auth_event.dart';
import '../../blocs/local_auth/local_auth_state.dart';

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
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  String _error = '';

  @override
  void initState() {
    super.initState();
    context.read<LocalAuthBloc>().add(CheckPinEvent(widget.userId));
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _verify() {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() => _error = 'Masukkan PIN');
      return;
    }
    context.read<LocalAuthBloc>().add(VerifyPinEvent(widget.userId, pin));
  }

  void _biometricLogin() {
    context.read<LocalAuthBloc>().add(BiometricLoginEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocalAuthBloc, LocalAuthState>(
        listener: (context, state) {
          if (state is PinVerified) {
            widget.onVerified();
          } else if (state is PinError) {
            setState(() => _error = state.message);
          } else if (state is PinReady) {
            if (state.isLockedOut) {
              setState(() => _error = 'Terlalu banyak percobaan. Tunggu 30 detik.');
            }
            if (state.biometricEnabled) {
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

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Masukkan PIN',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Verifikasi untuk melanjutkan',
                      style: TextStyle(
                        color: AppTheme.neutralGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      obscureText: true,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: '••••••',
                        hintStyle: TextStyle(
                          fontSize: 24,
                          letterSpacing: 8,
                          color: AppTheme.neutralGrey.withValues(alpha: 0.4),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      enabled: !isLocked,
                    ),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _error,
                          style: const TextStyle(
                            color: AppTheme.warningRed,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLocked ? null : _verify,
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
                          onPressed: isLocked ? null : _biometricLogin,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Gunakan Sidik Jari'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: widget.onSkip,
                      child: const Text(
                        'Login dengan Password',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
