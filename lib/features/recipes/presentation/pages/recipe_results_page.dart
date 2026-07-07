import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/back_icon_button.dart';
import '../../data/models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';

/// "اینا رو می‌تونی بپزی" — only ever reached with real suggestions in hand;
/// the empty-pantry and service-failure cases now have their own dedicated
/// screens instead of an inline message here.
class RecipeResultsPage extends StatelessWidget {
  const RecipeResultsPage({super.key, required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.appBackground,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                child: Row(
                  children: [
                    const BackIconButton(),
                    const SizedBox(width: 12),
                    Expanded(child: Text('اینا رو می‌تونی بپزی', style: AppText.screenTitle())),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('بر اساس چیزایی که توی قفسه‌ته', style: AppText.bodySoft(color: AppColors.inkSoft).copyWith(fontSize: 13)),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                  itemCount: recipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
