import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../pantry/presentation/pages/pantry_page.dart';

/// "قفسه‌ت فعلاً خالیه" — the *real* trigger is tapping "پیدا کن غذا" with
/// zero pantry items (from [PantryPage]) or the suggest endpoint reporting
/// an empty pantry (from [RecipeLoadingPage]), not a demo shortcut.
class RecipeErrorEmptyPantryPage extends StatelessWidget {
  const RecipeErrorEmptyPantryPage({super.key});

  void _backToPantryAndAdd(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PantryPage(openAddSheetOnStart: true)),
      (route) => false,
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
                    child: const Text('🗄️', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(height: 14),
                  Text('قفسه‌ت فعلاً خالیه', style: AppText.cardTitle().copyWith(fontSize: 17)),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      'برای اینکه بتونیم غذا پیشنهاد بدیم، اول باید بدونیم چی توی خونه داری',
                      textAlign: TextAlign.center,
                      style: AppText.bodySoft(height: 1.85),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _backToPantryAndAdd(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.olive,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        'برگرد و یه ماده اضافه کن',
                        style: AppText.button(color: AppColors.surface).copyWith(fontSize: 14.5, fontWeight: FontWeight.w700),
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
