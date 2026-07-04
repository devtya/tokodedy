import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import 'home_page.dart';
import '../../blocs/local_auth/local_auth_bloc.dart';
import '../../blocs/local_auth/local_auth_event.dart';
import '../../blocs/local_auth/local_auth_state.dart';
import '../../../presentation/widgets/pin_numpad.dart';

enum _PinSetupStep { create, confirm }

class PinSetupPage extends StatefulWidget {
  final String userId;

  const PinSetupPage({super.key, required this.userId});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  String _pin = '';
  String _confirmPin = '';
  String _error = '';
  _PinSetupStep _step = _PinSetupStep.create;

  void _save() {
    if (_pin.isEmpty || _confirmPin.isEmpty) {
      setState(() => _error = 'PIN tidak boleh kosong');
      return;
    }
    if (_pin.length < 4 || _pin.length > 6) {
      setState(() => _error = 'PIN harus 4-6 digit');
      return;
    }
    if (_pin != _confirmPin) {
      setState(() {
        _error = 'PIN tidak cocok';
        _step = _PinSetupStep.create;
        _pin = '';
        _confirmPin = '';
      });
      return;
    }
    context.read<LocalAuthBloc>().add(SetPinEvent(widget.userId, _pin));
  }

  void _onDigit(String digit) {
    setState(() {
      _error = '';
      if (_step == _PinSetupStep.create) {
        if (_pin.length < 6) {
          _pin += digit;
        }
      } else {
        if (_confirmPin.length < 6) {
          _confirmPin += digit;
        }
      }
    });
  }

  void _onBackspace() {
    setState(() {
      _error = '';
      if (_step == _PinSetupStep.create) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      }
    });
  }

  void _goToConfirm() {
    if (_pin.length < 4) {
      setState(() => _error = 'PIN minimal 4 digit');
      return;
    }
    setState(() {
      _step = _PinSetupStep.confirm;
      _error = '';
    });
  }

  void _goBackToCreate() {
    setState(() {
      _step = _PinSetupStep.create;
      _confirmPin = '';
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.background : AppTheme.lightBackground,
      appBar: AppBar(
        title: Text(
          _step == _PinSetupStep.create ? 'Buat PIN Baru' : 'Konfirmasi PIN',
        ),
      ),
      body: BlocConsumer<LocalAuthBloc, LocalAuthState>(
        listener: (context, state) {
          if (state is PinSetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PIN berhasil disimpan'),
                backgroundColor: AppTheme.primary,
              ),
            );
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            }
          } else if (state is PinError) {
            setState(() => _error = state.message);
          }
        },
        builder: (context, state) {
          if (state is LocalAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentPin =
              _step == _PinSetupStep.create ? _pin : _confirmPin;
          final canProceed = _step == _PinSetupStep.create
              ? _pin.length >= 4
              : _confirmPin.length >= 4;

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
                            Icons.pin,
                            size: 64,
                            color: isDark ? AppTheme.primary : AppTheme.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _step == _PinSetupStep.create
                                ? 'Buat PIN Baru'
                                : 'Konfirmasi PIN',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.white : AppTheme.lightText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _step == _PinSetupStep.create
                                ? 'Masukkan PIN 4-6 digit'
                                : 'Masukkan ulang PIN untuk konfirmasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.neutralGrey
                                  : AppTheme.lightTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),
                          PinDots(
                            digitCount: currentPin.length,
                            totalDigits: 6,
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
                              onPressed: !canProceed
                                  ? null
                                  : (_step == _PinSetupStep.create
                                      ? _goToConfirm
                                      : _save),
                              child: Text(
                                _step == _PinSetupStep.create
                                    ? 'LANJUT'
                                    : 'SIMPAN PIN',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_step == _PinSetupStep.confirm) ...[
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: _goBackToCreate,
                              child: Text(
                                'Kembali',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? AppTheme.primary
                                      : AppTheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              PinNumpad(
                enabled: true,
                onDigit: _onDigit,
                onBackspace: _onBackspace,
              ),
            ],
          );
        },
      ),
    );
  }
}
