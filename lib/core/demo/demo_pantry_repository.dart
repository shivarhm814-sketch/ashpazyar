import '../../features/pantry/data/models/ingredient.dart';
import '../../features/pantry/data/models/pantry_item.dart';
import '../../features/pantry/data/pantry_repository.dart';

/// Ingredient names offered by the demo's "add ingredient" search — mirrors
/// the full real backend's /ingredients/search catalog (kitchen staples,
/// spices, fast-food/cafe items) so the demo search isn't missing anything
/// the bundled recipes call for.
const demoIngredientCatalog = <String>[
  // اصلی و تره‌بار
  'پیاز', 'سیب‌زمینی', 'گوجه‌فرنگی', 'برنج', 'تخم‌مرغ', 'روغن', 'نمک',
  'سیر', 'مرغ', 'گوشت چرخ‌کرده', 'لپه', 'عدس', 'ماست', 'پنیر', 'نان',
  'فلفل دلمه‌ای', 'هویج', 'لیمو ترش', 'ماکارونی',
  'خیار', 'لوبیا قرمز', 'رب گوجه‌فرنگی', 'گردو', 'بادمجان', 'کشک',
  'زرشک', 'سبزی قورمه', 'رشته آش', 'اسفناج', 'آرد', 'پنیر پیتزا',
  'خامه', 'تورتیلا', 'کاهو', 'رب انار',
  // ادویه‌ها
  'زردچوبه', 'زعفران', 'زیره', 'فلفل سیاه', 'فلفل قرمز', 'دارچین',
  'هل', 'سماق', 'پاپریکا', 'ادویه کاری', 'آویشن', 'اورگانو', 'زنجبیل',
  // فست‌فود و سایر
  'نان همبرگر', 'سوسیس', 'کالباس', 'نان هات‌داگ', 'نان پیتا',
  'سس مایونز', 'سس کچاپ', 'سس خردل', 'قارچ', 'نخود', 'ماهی',
  'کره', 'شکر', 'عسل',
  // کافی‌شاپ و دسر
  'قهوه', 'شیر', 'شکلات', 'وانیل', 'کارامل', 'نعنا', 'چای', 'موز', 'توت‌فرنگی',
  // فست‌فود و ساندویچی بیشتر
  'نان ساندویچ', 'سس باربیکیو', 'سس تند', 'خیارشور', 'پنیر چدار', 'زیتون', 'بال مرغ',
  // کبابی و رستوران سنتی
  'نان لواش', 'نان سنگک', 'دوغ', 'ترشی', 'سس سویا', 'کلم',
  // فست‌فود، دریایی و مواد تکمیلی
  'باقالی', 'شوید', 'تره', 'آلو', 'میگو', 'تمر هندی',
  'پنیر فتا', 'پنیر پارمزان', 'گوشت گوساله', 'نخود سبز', 'ذرت',
  // افزوده‌شده برای دستورهای جدید
  'کرفس', 'بامیه', 'جگر', 'برگ مو', 'گندم', 'شیر نارگیل', 'نودل برنجی',
  // میوه‌ها، آجیل، سبزی‌های بیشتر و سایر
  'سیب', 'پرتقال', 'انگور', 'هلو', 'گلابی', 'هندوانه', 'خربزه', 'کیوی',
  'انبه', 'آناناس', 'نارنگی', 'خرما', 'کشمش', 'بادام', 'پسته', 'فندق',
  'تخمه آفتابگردان', 'کنجد', 'کدو سبز', 'بروکلی', 'گل‌کلم', 'چغندر',
  'تربچه', 'لوبیا سبز', 'نخود فرنگی', 'جعفری', 'گشنیز', 'ریحان', 'ترخون',
  'ماهی سالمون', 'ماهی تن', 'بوقلمون', 'جگر مرغ', 'پنیر گودا', 'پنیر موزارلا',
  'ماست یونانی', 'خامه ترش', 'سرکه', 'روغن زیتون', 'روغن کنجد', 'آبغوره', 'گلاب',
];

/// Stands in for [PantryRepository] in the offline demo build: starts with
/// an empty in-memory pantry, same as a brand-new real account would.
class DemoPantryRepository extends PantryRepository {
  final List<PantryItem> _items = [];
  int _counter = 100;

  @override
  Future<List<PantryItem>> fetchItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.of(_items);
  }

  @override
  Future<PantryItem> addItem(String name) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final item = PantryItem(id: 'd${_counter++}', name: name);
    _items.add(item);
    return item;
  }

  @override
  Future<void> removeItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _items.removeWhere((i) => i.id == id);
  }

  @override
  Future<List<Ingredient>> searchIngredients(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final trimmed = query.trim();
    return demoIngredientCatalog
        .where((name) => trimmed.isEmpty || name.contains(trimmed))
        .toSet()
        .map((name) => Ingredient(id: name, name: name))
        .toList();
  }
}
