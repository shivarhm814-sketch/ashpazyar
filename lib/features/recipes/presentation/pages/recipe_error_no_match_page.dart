import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// "با این مواد و بودجه، دستور پختی پیدا نشد" — reached when the pantry has
/// items but nothing matched within the chosen budget tier. Distinct from
/// [RecipeErrorEmptyPantryPage] because the fix is different: raise the
/// budget (or add another ingredient), not "add anything at all" — so the
/// CTA pops back to Budget Selection instead of routing to the pantry.
class RecipeErrorNoMatchPage extends StatelessWidget {
  const RecipeErrorNoMatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(color: AppColors.tomatoSoft, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: const Text('🍽️', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(height: 14),
                  Text('با این مواد پیشنهادی پیدا نشد', style: AppText.cardTitle().copyWith(fontSize: 17)),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: Text(
                      'با این بودجه هیچ‌کدوم از دستورها جور درنیومد. بودجه رو زیاد کن یا برگرد و یکی دو ماده‌ی دیگه اضافه کن',
                      textAlign: TextAlign.center,
                      style: AppText.bodySoft(height: 1.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.turmeric,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        'برگرد و بودجه رو عوض کن',
                        style: AppText.button().copyWith(fontSize: 14.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
