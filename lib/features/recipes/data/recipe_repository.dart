import '../../../core/network/api_client.dart';
import 'models/budget_tier.dart';
import 'models/recipe.dart';

/// Why `POST /recipes/suggest` did not return recipes. Mirrors the handoff's
/// two real error screens (Empty Pantry / Service Failure) — the Loading
/// page routes on this instead of the prototype's timed transition.
enum RecipeSuggestFailureReason { emptyPantry, serviceFailure }

/// Result of a suggest call: either a recipe list, or a typed failure reason
/// for the Loading page to route on.
class RecipeSuggestResult {
  const RecipeSuggestResult.success(List<Recipe> this.recipes) : failureReason = null;

  const RecipeSuggestResult.failure(RecipeSuggestFailureReason reason)
      : recipes = null,
        failureReason = reason;

  final List<Recipe>? recipes;
  final RecipeSuggestFailureReason? failureReason;

  bool get isSuccess => failureReason == null;
}

class RecipeRepository {
  RecipeRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<RecipeSuggestResult> suggestRecipes({
    required List<String> pantryItemNames,
    required BudgetTier budgetTier,
  }) async {
    if (pantryItemNames.isEmpty) {
      return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.emptyPantry);
    }

    try {
      final response = await _apiClient.post('/recipes/suggest', body: {
        'pantryItems': pantryItemNames,
        'budgetTier': budgetTier.id,
      });
      final recipes = (response['recipes'] as List).map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
      return RecipeSuggestResult.success(recipes);
    } on ApiException catch (e) {
      if (e.statusCode == 422 || e.statusCode == 409) {
        return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.emptyPantry);
      }
      return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.serviceFailure);
    } catch (_) {
      return const RecipeSuggestResult.failure(RecipeSuggestFailureReason.serviceFailure);
    }
  }
}
