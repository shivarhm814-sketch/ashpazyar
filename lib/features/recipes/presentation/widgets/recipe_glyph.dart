/// Maps a recipe title (and, as a fallback, its category) to a
/// representative food emoji — used as a lightweight stand-in wherever a
/// real photo (`Recipe.imageUrl`) isn't available yet. No photography or
/// image generation is available, so this keeps the UI visually complete
/// without inventing fake image URLs.
String dishGlyph(String title, String category) {
  final normalized = title.replaceAll('‌', '').replaceAll(' ', '');
  for (final entry in _glyphsByKeyword.entries) {
    if (normalized.contains(entry.key)) return entry.value;
  }
  switch (category) {
    case 'سالاد':
      return '🥗';
    case 'کافی‌شاپ':
      return '☕';
    case 'فست‌فود':
      return '🍔';
    case 'فرنگی':
      return '🍝';
    default:
      return '🍲';
  }
}

const _glyphsByKeyword = <String, String>{
  'پیتزا': '🍕',
  'همبرگر': '🍔',
  'برگر': '🍔',
  'هاتداگ': '🌭',
  'ساندویچ': '🥪',
  'رپ': '🌯',
  'تاکو': '🌮',
  'بوریتو': '🌯',
  'کوئسادیا': '🫓',
  'فلافل': '🧆',
  'شاورما': '🌯',
  'سوخاری': '🍗',
  'ناگت': '🍗',
  'بال': '🍗',
  'استیک': '🥩',
  'کباب': '🍢',
  'جوجه': '🍗',
  'کوفته': '🍲',
  'کتلت': '🥘',
  'دلمه': '🫑',
  'میرزاقاسمی': '🍆',
  'کشکبادمجان': '🍆',
  'قورمهسبزی': '🍲',
  'قیمه': '🍲',
  'فسنجان': '🍲',
  'خورش': '🍲',
  'آبگوشت': '🍲',
  'آش': '🍜',
  'سوپ': '🍜',
  'حلیم': '🍜',
  'پلو': '🍚',
  'چلو': '🍚',
  'تهچین': '🍚',
  'دمی': '🍚',
  'ریزوتو': '🍚',
  'کبسه': '🍛',
  'کاری': '🍛',
  'پادتای': '🍜',
  'پلوف': '🍚',
  'لازانیا': '🍝',
  'اسپاگتی': '🍝',
  'پاستا': '🍝',
  'ماکارونی': '🍝',
  'سالاد': '🥗',
  'کوکو': '🥘',
  'املت': '🍳',
  'نیمرو': '🍳',
  'تخممرغ': '🍳',
  'زیتونپرورده': '🫒',
  'ماستونعنا': '🥣',
  'ماستوخیار': '🥣',
  'ترشتره': '🍲',
  'باقلاقاتق': '🍲',
  'ماهی': '🐟',
  'میگو': '🍤',
  'قلیه': '🍲',
  'شله': '🍲',
  'سمبوسه': '🥟',
  'پیراشکی': '🥟',
  'وج': '🍟',
  'سرخکرده': '🍟',
  'لاته': '☕',
  'ماکیاتو': '☕',
  'قهوه': '☕',
  'شیک': '🥤',
  'اسموتی': '🥤',
  'چای': '🍵',
  'کیک': '🍰',
  'ترخینه': '🍜',
};
