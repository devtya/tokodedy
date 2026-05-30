import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/local_auth/local_auth_bloc.dart';
import '../../blocs/local_auth/local_auth_event.dart';
import '../../blocs/local_auth/local_auth_state.dart';

class PinSetupPage extends StatefulWidget {
  final String userId;

  const PinSetupPage({super.key, required this.userId});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirm = true;
  String _error = '';

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _save() {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.isEmpty || confirm.isEmpty) {
      setState(() => _error = 'PIN tidak boleh kosong');
      return;
    }
    if (pin.length < 4 || pin.length > 6) {
      setState(() => _error = 'PIN harus 4-6 digit');
      return;
    }
    if (pin != confirm) {
      setState(() => _error = 'PIN tidak cocok');
      return;
    }
    if (pin == confirm) {
      context.read<LocalAuthBloc>().add(SetPinEvent(widget.userId, pin));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atur PIN')),
      body: BlocConsumer<LocalAuthBloc, LocalAuthState>(
        listener: (context, state) {
          if (state is PinSetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('PIN berhasil disimpan'),
                backgroundColor: AppTheme.primaryGreen,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PinError) {
            setState(() => _error = state.message);
          }
        },
        builder: (context, state) {
          if (state is LocalAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin,
                      size: 64,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Buat PIN Keamanan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'PIN digunakan untuk login cepat tanpa password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.neutralGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _pinController,
                      obscureText: _obscurePin,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'PIN (4-6 digit)',
                        hintStyle: const TextStyle(fontSize: 16),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePin
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => _obscurePin = !_obscurePin);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Konfirmasi PIN',
                        hintStyle: const TextStyle(fontSize: 16),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            );
                          },
                        ),
                      ),
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
                        onPressed: _save,
                        child: const Text(
                          'SIMPAN PIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Nanti Saja',
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
