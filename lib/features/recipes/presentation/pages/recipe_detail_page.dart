import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/recipe.dart';
import '../widgets/recipe_glyph.dart';

/// Olive-colored header block (back + title + desc + meta badges) followed
/// by category/nutrition info, from-pantry / to-buy ingredient chips, and
/// numbered cooking steps.
class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipe});

  final Recipe recipe;

  String _amountFor(String name) {
    for (final line in recipe.ingredients) {
      if (line.name == name) return line.amount;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = recipe.province != null ? '${recipe.category} · ${recipe.province}' : recipe.category;
    final dietaryLabels = [
      if (recipe.isVegan) 'وگان',
      if (recipe.isVegetarian) 'گیاهی',
      if (recipe.isGlutenFree) 'بدون گلوتن',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.olive,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: recipe.imageUrl != null
                            ? Image.network(
                                recipe.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _RecipeGlyphBanner(recipe: recipe),
                              )
                            : _RecipeGlyphBanner(recipe: recipe),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(Icons.arrow_forward, size: 18, color: AppColors.surface),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(recipe.title, style: AppText.screenTitle(color: AppColors.surface).copyWith(fontSize: 21)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppText.chip(color: AppColors.oliveSoft).copyWith(fontSize: 12.5)),
                    const SizedBox(height: 8),
                    Text(recipe.desc, style: AppText.bodySoft(color: AppColors.oliveSoft, height: 1.7).copyWith(fontSize: 13)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _HeaderBadge(recipe.cost),
                        _HeaderBadge('آماده‌سازی ${recipe.prepTime}'),
                        _HeaderBadge('پخت ${recipe.cookTime}'),
                        _HeaderBadge('${recipe.servings} نفر'),
                        _HeaderBadge(recipe.difficulty),
                      ],
                    ),
                    if (dietaryLabels.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final label in dietaryLabels) _DietaryBadge(label)],
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    if (recipe.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in recipe.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(AppRadius.pill)),
                              child: Text('#$tag', style: AppText.chip().copyWith(fontSize: 11.5)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('ارزش غذایی (هر پرس)', style: AppText.cardTitle().copyWith(fontSize: 14)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _NutritionStat(label: 'کالری', value: '${recipe.nutrition.calories}')),
                        Expanded(child: _NutritionStat(label: 'پروتئین', value: '${recipe.nutrition.proteinGrams.toStringAsFixed(0)} گرم')),
                        Expanded(child: _NutritionStat(label: 'چربی', value: '${recipe.nutrition.fatGrams.toStringAsFixed(0)} گرم')),
                        Expanded(child: _NutritionStat(label: 'کربوهیدرات', value: '${recipe.nutrition.carbsGrams.toStringAsFixed(0)} گرم')),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '✓ از قفسه‌ات استفاده می‌شه',
                        style: AppText.cardTitle(color: AppColors.olive).copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final ing in recipe.fromPantry)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(color: AppColors.oliveSoft, borderRadius: BorderRadius.circular(AppRadius.pill)),
                            child: Text(
                              _amountFor(ing).isEmpty ? ing : '$ing (${_amountFor(ing)})',
                              style: AppText.chip(color: AppColors.oliveTextOnSoft),
                            ),
                          ),
                      ],
                    ),
                    if (recipe.needsShopping) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '🛒 باید بخری',
                          style: AppText.cardTitle(color: AppColors.tomato).copyWith(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final ing in recipe.toBuy)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.tomatoSoft, borderRadius: BorderRadius.circular(AppRadius.pill)),
                              child: Text(
                                _amountFor(ing).isEmpty ? ing : '$ing (${_amountFor(ing)})',
                                style: AppText.chip(color: AppColors.tomatoTextOnSoft),
                              ),
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('مراحل پخت', style: AppText.cardTitle().copyWith(fontSize: 14)),
                    ),
                    const SizedBox(height: 10),
                    for (final step in recipe.steps)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(color: AppColors.turmeric, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text('${step.n}', style: AppText.chip(color: AppColors.ink).copyWith(fontSize: 12.5, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(step.text, style: AppText.body(color: const Color(0xFF3A2E1E), height: 1.85).copyWith(fontSize: 14))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown in place of a real photo when [Recipe.imageUrl] isn't set (no
/// photography/image-generation is available) — a large glyph on a soft
/// tint so the header still reads as a "dish photo" slot.
class _RecipeGlyphBanner extends StatelessWidget {
  const _RecipeGlyphBanner({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.14),
      alignment: Alignment.center,
      child: Text(dishGlyph(recipe.title, recipe.category), style: const TextStyle(fontSize: 56)),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: AppText.chip(color: AppColors.surface).copyWith(fontSize: 12)),
    );
  }
}

class _DietaryBadge extends StatelessWidget {
  const _DietaryBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.turmeric, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: AppText.chip(color: AppColors.ink).copyWith(fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }
}

class _NutritionStat extends StatelessWidget {
  const _NutritionStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: AppText.cardTitle().copyWith(fontSize: 13)),
          const SizedBox(height: 2),
          Text(label, style: AppText.caption()),
        ],
      ),
    );
  }
}
