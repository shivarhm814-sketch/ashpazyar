import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Square 36x36 chevron button used in every screen header that supports
/// back-navigation (Budget, Results, Detail).
class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key, this.onPressed, this.iconColor = AppColors.ink, this.background});

  final VoidCallback? onPressed;
  final Color iconColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background ?? Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: background == null
              ? BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                )
              : BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.arrow_forward, size: 18, color: iconColor),
        ),
      ),
    );
  }
}
