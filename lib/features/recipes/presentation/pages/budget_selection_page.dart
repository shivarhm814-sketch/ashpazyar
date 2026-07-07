import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/back_icon_button.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/budget_tier.dart';
import 'recipe_loading_page.dart';

/// "چقدر بودجه‌ی اضافه داری؟" — pick how much extra the user will spend on
/// missing ingredients before requesting suggestions.
class BudgetSelectionPage extends StatefulWidget {
  const BudgetSelectionPage({super.key, required this.pantryItemNames});

  final List<String> pantryItemNames;

  @override
  State<BudgetSelectionPage> createState() => _BudgetSelectionPageState();
}

class _BudgetSelectionPageState extends State<BudgetSelectionPage> {
  BudgetTier? _selected;

  void _continue() {
    if (_selected == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeLoadingPage(pantryItemNames: widget.pantryItemNames, budgetTier: _selected!),
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                child: Row(
                  children: [
                    const BackIconButton(),
                    const SizedBox(width: 12),
                    Expanded(child: Text('چقدر بودجه‌ی اضافه داری؟', style: AppText.screenTitle())),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('اگه یکی دو ماده کم داشته باشی، چقدر حاضری خرج کنی؟', style: AppText.bodySoft()),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  children: [
                    for (final tier in BudgetTier.values) ...[
                      _BudgetCard(
                        tier: tier,
                        selected: _selected == tier,
                        onTap: () => setState(() => _selected = tier),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                child: PrimaryButton(
                  label: 'ادامه',
                  enabled: _selected != null,
                  onPressed: _continue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.tier, required this.selected, required this.onTap});

  final BudgetTier tier;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: selected ? AppColors.turmeric : AppColors.border, width: 2),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.turmeric.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 6))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(tier.label, style: AppText.cardTitle())),
                if (selected)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(color: AppColors.turmeric, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Icon(Icons.check, size: 13, color: AppColors.ink),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(tier.description, style: AppText.bodySoft(height: 1.7)),
          ],
        ),
      ),
    );
  }
}
