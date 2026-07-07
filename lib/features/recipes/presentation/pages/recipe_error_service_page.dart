import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/budget_tier.dart';
import '../../data/recipe_repository.dart';
import 'recipe_loading_page.dart';

/// "یه مشکلی پیش اومد" — reached when `POST /recipes/suggest` fails for a
/// reason unrelated to the user's pantry (network/5xx). Retry re-runs the
/// Loading → Results flow with the same pantry/budget inputs.
class RecipeErrorServicePage extends StatelessWidget {
  const RecipeErrorServicePage({
    super.key,
    required this.pantryItemNames,
    required this.budgetTier,
    this.recipeRepository,
  });

  final List<String> pantryItemNames;
  final BudgetTier budgetTier;
  final RecipeRepository? recipeRepository;

  void _retry(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RecipeLoadingPage(
          pantryItemNames: pantryItemNames,
          budgetTier: budgetTier,
          recipeRepository: recipeRepository,
        ),
      ),
    );
  }

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
                    child: const Text('⚠️', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(height: 14),
                  Text('یه مشکلی پیش اومد', style: AppText.cardTitle().copyWith(fontSize: 17)),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      'سرویس پیشنهاد غذا الان جواب نداد. مشکل از قفسه‌ی تو نیست، یه بار دیگه امتحان کن',
                      textAlign: TextAlign.center,
                      style: AppText.bodySoft(height: 1.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _retry(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.turmeric,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        'تلاش دوباره',
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
