import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../features/recipes/data/models/budget_tier.dart';
import '../../features/recipes/data/models/recipe.dart';
import '../../features/recipes/data/recipe_repository.dart';

const _budgetToBuyLimit = <String, int>{'low': 0, 'mid': 2, 'open': 999};

/// Stands in for [RecipeRepository] in the offline demo build: matches a
/// bundled set of full-schema sample recipes (assets/demo_recipes.json)
/// against the demo pantry, mirroring the real backend's matching rules
/// (at least one ingredient from the pantry, and no more missing ingredients
/// than the chosen budget tier allows).
class DemoRecipeRepository extends RecipeRepository {
  List<Map<String, dynamic>>? _catalog;

  Future<List<Map<String, dynamic>>> _loadCatalog() async {
    final cached = _catalog;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/demo_recipes.json');
    final decoded = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _catalog = decoded;
    return decoded;
  }

  @override
  Future<RecipeSuggestResult> suggestRecipes({
    required List<String> pantryItemNames,
    required BudgetTier budgetTier,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    if (pantryItemNames.isEmpty) {
      return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.emptyPantry);
    }

    final catalog = await _loadCatalog();
    final pantrySet = pantryItemNames.toSet();
    final buyLimit = _budgetToBuyLimit[budgetTier.id] ?? 0;

    final matches = <Recipe>[];
    for (final entry in catalog) {
      final ingredients = (entry['ingredients'] as List).cast<Map<String, dynamic>>();
      final names = ingredients.map((i) => i['name'] as String).toList();
      final fromPantry = names.where(pantrySet.contains).toList();
      final toBuy = names.where((n) => !pantrySet.contains(n)).toList();
      if (fromPantry.isEmpty || toBuy.length > buyLimit) continue;

      matches.add(Recipe.fromJson({
        ...entry,
        'fromPantry': fromPantry,
        'toBuy': toBuy,
      }));
    }

    if (matches.isEmpty) {
      return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.noMatch);
    }
    return RecipeSuggestResult.success(matches);
  }
}
