import '../../features/pantry/data/models/ingredient.dart';
import '../../features/pantry/data/models/pantry_item.dart';
import '../../features/pantry/data/pantry_repository.dart';

/// Common ingredient names offered by the demo's "add ingredient" search —
/// mirrors the shape of the real backend's /ingredients/search catalog.
const demoIngredientCatalog = <String>[
  'پیاز', 'سیب‌زمینی', 'گوجه‌فرنگی', 'برنج', 'تخم‌مرغ', 'روغن', 'نمک', 'سیر',
  'مرغ', 'گوشت چرخ‌کرده', 'لپه', 'عدس', 'ماست', 'پنیر', 'نان', 'فلفل دلمه‌ای',
  'هویج', 'لیمو ترش', 'ماکارونی', 'خیار', 'لوبیا قرمز', 'رب گوجه‌فرنگی',
  'گردو', 'بادمجان', 'کشک', 'زرشک', 'زعفران', 'رب انار', 'نان همبرگر',
  'سوسیس', 'نان پیتا', 'نان لواش', 'زیتون', 'پنیر فتا', 'ماکارونی', 'قهوه',
  'شیر', 'شکلات', 'موز',
];

/// Stands in for [PantryRepository] in the offline demo build: keeps a
/// small in-memory pantry seeded with a few items so "پیدا کن غذا" has
/// something to work with right away.
class DemoPantryRepository extends PantryRepository {
  final List<PantryItem> _items = [
    const PantryItem(id: 'd1', name: 'سیب‌زمینی'),
    const PantryItem(id: 'd2', name: 'تخم‌مرغ'),
    const PantryItem(id: 'd3', name: 'پیاز'),
    const PantryItem(id: 'd4', name: 'مرغ'),
    const PantryItem(id: 'd5', name: 'برنج'),
  ];
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
