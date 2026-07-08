import 'package:flutter/material.dart';

import '../../../../core/demo/demo_mode.dart';
import '../../../../core/demo/demo_recipe_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/budget_tier.dart';
import '../../data/recipe_repository.dart';
import 'recipe_error_empty_pantry_page.dart';
import 'recipe_error_no_match_page.dart';
import 'recipe_error_service_page.dart';
import 'recipe_results_page.dart';

/// "داره توی قفسه‌ت دنبال ایده می‌گرده..." — bridge screen while the AI
/// suggestion request is in flight. Unlike the design prototype (a fixed
/// 2.2s timer), this waits for the real `POST /recipes/suggest` response and
/// routes on its actual result: success → Results, empty pantry / service
/// failure → their dedicated error screens.
class RecipeLoadingPage extends StatefulWidget {
  const RecipeLoadingPage({
    super.key,
    required this.pantryItemNames,
    required this.budgetTier,
    this.recipeRepository,
  });

  final List<String> pantryItemNames;
  final BudgetTier budgetTier;
  final RecipeRepository? recipeRepository;

  @override
  State<RecipeLoadingPage> createState() => _RecipeLoadingPageState();
}

class _RecipeLoadingPageState extends State<RecipeLoadingPage> {
  late final RecipeRepository _recipeRepository =
      widget.recipeRepository ?? (isDemoMode ? DemoRecipeRepository() : RecipeRepository());

  @override
  void initState() {
    super.initState();
    _requestSuggestions();
  }

  Future<void> _requestSuggestions() async {
    final result = await _recipeRepository.suggestRecipes(
      pantryItemNames: widget.pantryItemNames,
      budgetTier: widget.budgetTier,
    );
    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RecipeResultsPage(recipes: result.recipes!)),
      );
      return;
    }

    switch (result.failureReason!) {
      case RecipeSuggestFailureReason.emptyPantry:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RecipeErrorEmptyPantryPage()),
        );
        break;
      case RecipeSuggestFailureReason.noMatch:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RecipeErrorNoMatchPage()),
        );
        break;
      case RecipeSuggestFailureReason.serviceFailure:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => RecipeErrorServicePage(
              pantryItemNames: widget.pantryItemNames,
              budgetTier: widget.budgetTier,
              recipeRepository: widget.recipeRepository,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PulsingBars(),
                  const SizedBox(height: 18),
                  Text(
                    'داره توی قفسه‌ت دنبال ایده می‌گرده...',
                    textAlign: TextAlign.center,
                    style: AppText.cardTitle().copyWith(fontSize: 16.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'چند ثانیه طول می‌کشه، داریم بهترین ترکیب رو پیدا می‌کنیم',
                    textAlign: TextAlign.center,
                    style: AppText.bodySoft(height: 1.8),
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

class _PulsingBars extends StatefulWidget {
  const _PulsingBars();

  @override
  State<_PulsingBars> createState() => _PulsingBarsState();
}

class _PulsingBarsState extends State<_PulsingBars> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = List.generate(
    3,
    (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 1100)),
  );

  static const _colors = [AppColors.turmeric, AppColors.tomato, AppColors.olive];
  static const _delaysMs = [0, 150, 300];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: _delaysMs[i]), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          AnimatedBuilder(
            animation: _controllers[i],
            builder: (context, child) {
              final t = CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut).value;
              final scale = 1 + 0.08 * t;
              final opacity = 1 - 0.25 * t;
              return Opacity(
                opacity: opacity,
                child: Transform.scale(scale: scale, child: child),
              );
            },
            child: Container(width: 20, height: 30, decoration: BoxDecoration(color: _colors[i], borderRadius: BorderRadius.circular(5))),
          ),
        ],
      ],
    );
  }
}
