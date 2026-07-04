import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PinNumpad extends StatelessWidget {
  final bool enabled;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  const PinNumpad({
    super.key,
    required this.enabled,
    required this.onDigit,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, ['1', '2', '3']),
          const SizedBox(height: 12),
          _buildRow(context, ['4', '5', '6']),
          const SizedBox(height: 12),
          _buildRow(context, ['7', '8', '9']),
          const SizedBox(height: 12),
          _buildBottomRow(context),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> digits) {
    return Row(
      children: digits
          .map((d) => _NumpadButton(
                label: d,
                enabled: enabled,
                onTap: () => onDigit(d),
              ))
          .toList(),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        _NumpadButton(
          label: '0',
          enabled: enabled,
          onTap: () => onDigit('0'),
        ),
        _NumpadButton(
          label: '⌫',
          enabled: enabled,
          onTap: onBackspace,
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NumpadButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: enabled
                ? (isDark ? AppTheme.surface : AppTheme.lightBackground)
                : (isDark ? AppTheme.surfaceContainerLow : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? (isDark ? AppTheme.border : AppTheme.lightBorder)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: enabled
                    ? (isDark ? AppTheme.white : AppTheme.lightText)
                    : (isDark ? AppTheme.grey : AppTheme.lightGrey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PinDots extends StatelessWidget {
  final int digitCount;
  final int totalDigits;
  final bool isError;

  const PinDots({
    super.key,
    required this.digitCount,
    required this.totalDigits,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDigits, (i) {
        final filled = i < digitCount;
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? (isError ? AppTheme.error : AppTheme.primary)
                : (isError
                    ? AppTheme.errorSoft
                    : AppTheme.grey.withValues(alpha: 0.25)),
          ),
        );
      }),
    );
  }
}
