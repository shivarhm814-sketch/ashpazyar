/// One numbered cooking-method step.
class RecipeStep {
  const RecipeStep({required this.n, required this.text});

  final int n;
  final String text;

  factory RecipeStep.fromJson(int index, dynamic json) {
    if (json is String) return RecipeStep(n: index + 1, text: json);
    final map = json as Map<String, dynamic>;
    return RecipeStep(n: (map['n'] as num?)?.toInt() ?? index + 1, text: map['text'] as String);
  }
}

/// One line of the recipe's full ingredient list, with its quantity
/// (e.g. "پیاز" — "۱ عدد"). Distinct from [Recipe.fromPantry]/[Recipe.toBuy],
/// which are the same ingredients reduced to bare names for the shopping-gap
/// chips on the Results/Detail screens.
class RecipeIngredientLine {
  const RecipeIngredientLine({required this.name, required this.amount});

  final String name;
  final String amount;

  factory RecipeIngredientLine.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientLine(name: json['name'] as String, amount: '${json['amount'] ?? ''}');
  }
}

/// Per-serving nutritional estimate.
class NutritionInfo {
  const NutritionInfo({
    required this.calories,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbsGrams,
  });

  final int calories;
  final double proteinGrams;
  final double fatGrams;
  final double carbsGrams;

  factory NutritionInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NutritionInfo(calories: 0, proteinGrams: 0, fatGrams: 0, carbsGrams: 0);
    return NutritionInfo(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinGrams: (json['protein'] as num?)?.toDouble() ?? 0,
      fatGrams: (json['fat'] as num?)?.toDouble() ?? 0,
      carbsGrams: (json['carbs'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// A suggested recipe as returned by `POST /recipes/suggest`.
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.desc,
    required this.category,
    this.province,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.cost,
    required this.difficulty,
    required this.ingredients,
    required this.fromPantry,
    required this.toBuy,
    required this.steps,
    required this.nutrition,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isVegan,
    this.imageUrl,
    required this.tags,
  });

  final String id;
  final String title;
  final String desc;

  /// e.g. "ایرانی", "محلی", "فرنگی", "فست‌فود".
  final String category;

  /// Province the dish originates from, only set for regional/local dishes.
  final String? province;

  final String prepTime;
  final String cookTime;
  final int servings;
  final String cost;
  final String difficulty;

  /// Full ingredient list with quantities (e.g. "پیاز" — "۱ عدد").
  final List<RecipeIngredientLine> ingredients;

  final List<String> fromPantry;
  final List<String> toBuy;
  final List<RecipeStep> steps;
  final NutritionInfo nutrition;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isVegan;
  final String? imageUrl;
  final List<String> tags;

  bool get needsShopping => toBuy.isNotEmpty;

  /// Combined time badge text, e.g. "20 دقیقه آماده‌سازی + 90 دقیقه پخت".
  String get time => '$prepTime آماده‌سازی + $cookTime پخت';

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final steps = (json['steps'] as List? ?? const []);
    final ingredients = (json['ingredients'] as List? ?? const []);
    return Recipe(
      id: '${json['id']}',
      title: json['title'] as String,
      desc: json['desc'] as String,
      category: json['category'] as String? ?? 'ایرانی',
      province: json['province'] as String?,
      prepTime: json['prepTime'] as String? ?? '—',
      cookTime: json['cookTime'] as String? ?? '—',
      servings: (json['servings'] as num?)?.toInt() ?? 2,
      cost: json['cost'] as String,
      difficulty: json['difficulty'] as String,
      ingredients: [for (final e in ingredients) RecipeIngredientLine.fromJson(e as Map<String, dynamic>)],
      fromPantry: (json['fromPantry'] as List? ?? const []).map((e) => '$e').toList(),
      toBuy: (json['toBuy'] as List? ?? const []).map((e) => '$e').toList(),
      steps: [for (var i = 0; i < steps.length; i++) RecipeStep.fromJson(i, steps[i])],
      nutrition: NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>?),
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      imageUrl: (json['image'] as String?)?.isNotEmpty == true ? json['image'] as String : null,
      tags: (json['tags'] as List? ?? const []).map((e) => '$e').toList(),
    );
  }
}
