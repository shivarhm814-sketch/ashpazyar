import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/recipe.dart';

/// A single suggestion on the Results screen: title (+ orange "+N خرید"
/// badge only when shopping is needed), description, and 3 neutral meta
/// badges (cost/time/difficulty).
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.cardLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.cardLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(recipe.title, style: AppText.cardTitle())),
                  if (recipe.needsShopping) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.tomato, borderRadius: BorderRadius.circular(AppRadius.pill)),
                      child: Text(
                        '+${recipe.toBuy.length} خرید',
                        style: AppText.chip(color: AppColors.surface).copyWith(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                recipe.province != null ? '${recipe.category} · ${recipe.province}' : recipe.category,
                style: AppText.caption(),
              ),
              const SizedBox(height: 6),
              Text(recipe.desc, style: AppText.bodySoft(height: 1.75)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaBadge(recipe.cost),
                  _MetaBadge(recipe.cookTime),
                  _MetaBadge(recipe.difficulty),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: AppText.chip().copyWith(fontSize: 12)),
    );
  }
}
