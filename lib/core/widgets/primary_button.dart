import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The app's single primary-CTA look (turmeric or olive fill, 50-54px tall).
/// Used across auth, pantry and recipe flows so every screen shares one
/// button shape/shadow instead of re-declaring it per page.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.turmeric,
    this.foregroundColor = AppColors.ink,
    this.height = 54,
    this.enabled = true,
    this.fontWeight = FontWeight.w800,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double height;
  final bool enabled;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final bg = enabled ? backgroundColor : AppColors.disabledBackground;
    final fg = enabled ? foregroundColor : AppColors.disabledForeground;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.cta),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.cta),
        onTap: enabled ? onPressed : null,
        child: Container(
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.cta),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: bg.withValues(alpha: 0.32),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppText.button(color: fg).copyWith(fontWeight: fontWeight),
          ),
        ),
      ),
    );
  }
}
