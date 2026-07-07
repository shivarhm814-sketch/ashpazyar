import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/pantry_item.dart';

/// The Pantry screen's signature element: a row of 7 jar silhouettes that
/// fill in with a graphic matching each added ingredient — a stand-in for a
/// future real photo of the user's shelf.
class JarRow extends StatelessWidget {
  const JarRow({super.key, required this.items, this.jarCount = 7});

  final List<PantryItem> items;
  final int jarCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sheet - 6),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(jarCount, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _Jar(item: i < items.length ? items[i] : null),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'هر ماده که اضافه می‌کنی، یکی از این شیشه‌ها با عکس همون ماده پر می‌شه',
            textAlign: TextAlign.center,
            style: AppText.caption(),
          ),
        ),
      ],
    );
  }
}

class _Jar extends StatelessWidget {
  const _Jar({required this.item});

  final PantryItem? item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 43,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // lid
          Positioned(
            left: 5,
            right: 5,
            top: 0,
            child: Container(height: 6, decoration: BoxDecoration(color: AppColors.borderDashed, borderRadius: BorderRadius.circular(3))),
          ),
          // jar body
          Positioned(
            left: 0,
            right: 0,
            top: 5,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.appBackground,
                border: Border.all(color: AppColors.border, width: 2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
              child: item != null ? Text(ingredientGlyph(item!.name), style: const TextStyle(fontSize: 16)) : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Maps a (Persian) ingredient name to a representative emoji glyph, so the
/// jar row and pantry list show a recognizable graphic per ingredient
/// instead of a generic icon. Falls back to a pantry-can emoji for anything
/// unrecognized.
String ingredientGlyph(String name) {
  final normalized = name.replaceAll('‌', '').replaceAll(' ', '').trim();
  for (final entry in _glyphsByKeyword.entries) {
    if (normalized.contains(entry.key)) return entry.value;
  }
  return '🥫';
}

const _glyphsByKeyword = <String, String>{
  'سیبزمینی': '🥔',
  'پیاز': '🧅',
  'گوجه': '🍅',
  'تخممرغ': '🥚',
  'مرغ': '🍗',
  'گوشت': '🥩',
  'برنج': '🍚',
  'ماکارونی': '🍝',
  'رشته': '🍜',
  'پنیر': '🧀',
  'ماست': '🥛',
  'خامه': '🥛',
  'کشک': '🥛',
  'سیر': '🧄',
  'زنجبیل': '🫚',
  'هویج': '🥕',
  'خیار': '🥒',
  'بادمجان': '🍆',
  'فلفلدلمه': '🫑',
  'فلفل': '🌶️',
  'گردو': '🌰',
  'لیمو': '🍋',
  'انار': '🍎',
  'زرشک': '🍒',
  'آرد': '🌾',
  'لپه': '🫘',
  'عدس': '🫘',
  'لوبیا': '🫘',
  'نخود': '🫘',
  'اسفناج': '🥬',
  'کاهو': '🥬',
  'قارچ': '🍄',
  'تورتیلا': '🌮',
  'همبرگر': '🍔',
  'هاتداگ': '🌭',
  'پیتا': '🫓',
  'ساندویچ': '🥪',
  'لواش': '🫓',
  'سنگک': '🫓',
  'نان': '🍞',
  'سوسیس': '🌭',
  'کالباس': '🥓',
  'کچاپ': '🍅',
  'مایونز': '🥚',
  'خردل': '🟡',
  'باربیکیو': '🍖',
  'تند': '🌶️',
  'ماهی': '🐟',
  'کره': '🧈',
  'عسل': '🍯',
  'روغن': '🫗',
  'رب': '🍅',
  'زعفران': '🌼',
  'نمک': '🧂',
  'زردچوبه': '🟡',
  'دارچین': '🟤',
  'زیره': '🌿',
  'سماق': '🌿',
  'آویشن': '🌿',
  'اورگانو': '🌿',
  'هل': '🌿',
  'پاپریکا': '🌶️',
  'کاری': '🍛',
  'سبزی': '🌿',
  'قهوه': '☕',
  'شیر': '🥛',
  'شکلات': '🍫',
  'وانیل': '🍨',
  'کارامل': '🍮',
  'نعنا': '🌿',
  'چای': '🍵',
  'موز': '🍌',
  'توتفرنگی': '🍓',
  'زیتون': '🫒',
  'دوغ': '🥤',
  'ترشی': '🫙',
  'سویا': '🍶',
  'کلم': '🥬',
};
