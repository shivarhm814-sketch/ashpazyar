import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Labeled 52px input shared by Login and Register (label above, hairline
/// border, cream surface) — matches the "1. Login/Sign up" handoff spec.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppText.label()),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: AppText.body(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppText.body(color: AppColors.captionMuted),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.control),
                borderSide: const BorderSide(color: AppColors.border, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.control),
                borderSide: const BorderSide(color: AppColors.border, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.control),
                borderSide: const BorderSide(color: AppColors.turmeric, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
