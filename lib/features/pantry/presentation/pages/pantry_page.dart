import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../recipes/presentation/pages/budget_selection_page.dart';
import '../../../recipes/presentation/pages/recipe_error_empty_pantry_page.dart';
import '../../data/models/pantry_item.dart';
import '../../data/pantry_repository.dart';
import '../widgets/add_ingredient_sheet.dart';
import '../widgets/jar_row.dart';

/// "قفسه من" — home screen: shows what the user has, lets them add/remove
/// items, and is the real entry point into the recipe-suggestion flow.
class PantryPage extends StatefulWidget {
  const PantryPage({
    super.key,
    this.pantryRepository,
    this.authRepository,
    this.openAddSheetOnStart = false,
  });

  final PantryRepository? pantryRepository;
  final AuthRepository? authRepository;

  /// Set when arriving back from the empty-pantry error screen, so the Add
  /// Ingredient sheet reopens immediately as the handoff's error CTA promises.
  final bool openAddSheetOnStart;

  @override
  State<PantryPage> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  late final PantryRepository _pantryRepository = widget.pantryRepository ?? PantryRepository();
  late final AuthRepository _authRepository = widget.authRepository ?? AuthRepository();

  List<PantryItem> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
    if (widget.openAddSheetOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openAddSheet());
    }
  }

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      final items = await _pantryRepository.fetchItems();
      if (!mounted) return;
      setState(() => _items = items);
    } catch (_) {
      // Pantry starts empty if the initial fetch fails; user can still add items.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addItem(String name) async {
    final created = await _pantryRepository.addItem(name);
    if (!mounted) return;
    setState(() => _items = [..._items, created]);
  }

  Future<void> _removeItem(PantryItem item) async {
    setState(() => _items = _items.where((i) => i.id != item.id).toList());
    try {
      await _pantryRepository.removeItem(item.id);
    } catch (_) {
      if (mounted) setState(() => _items = [..._items, item]);
    }
  }

  void _openAddSheet() {
    AddIngredientSheet.show(
      context,
      pantryRepository: _pantryRepository,
      existingItemNames: _items.map((e) => e.name).toSet(),
      onAdd: _addItem,
    );
  }

  Future<void> _logout() async {
    await _authRepository.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _findFood() {
    if (_items.isEmpty) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecipeErrorEmptyPantryPage()));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BudgetSelectionPage(pantryItemNames: _items.map((e) => e.name).toList())),
      );
    }
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('قفسه من', style: AppText.screenTitleLarge()),
                    PopupMenuButton<void>(
                      offset: const Offset(0, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: _logout,
                          child: Text('خروج از حساب', style: AppText.body()),
                        ),
                      ],
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.more_vert, size: 18, color: AppColors.inkSoft),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                child: JarRow(items: _items),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.turmeric))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _items.isEmpty ? _EmptyPantry(onAdd: _openAddSheet) : _PantryList(items: _items, onRemove: _removeItem),
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
                decoration: const BoxDecoration(
                  color: AppColors.appBackground,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: [
                    _DashedAddRow(onTap: _openAddSheet),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _findFood,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.turmeric,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.cta)),
                        ),
                        child: Text('پیدا کن غذا', style: AppText.button().copyWith(fontWeight: FontWeight.w800)),
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

class _EmptyPantry extends StatelessWidget {
  const _EmptyPantry({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: const Text('🥫', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 14),
          Text('هنوز چیزی توی قفسه‌ت نیست', style: AppText.cardTitle().copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Text(
              'هر چی توی خونه داری رو اضافه کن، بعد بهت می‌گیم با همونا چی می‌تونی بپزی',
              textAlign: TextAlign.center,
              style: AppText.bodySoft(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.olive,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                '+ افزودن اولین ماده',
                style: AppText.button(color: AppColors.surface).copyWith(fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PantryList extends StatelessWidget {
  const _PantryList({required this.items, required this.onRemove});

  final List<PantryItem> items;
  final void Function(PantryItem item) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.card - 2),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: AppColors.oliveSoft, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text(ingredientGlyph(item.name), style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(item.name, style: AppText.body())),
              GestureDetector(
                onTap: () => onRemove(item),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 18, color: AppColors.tomato),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// "افزودن ماده جدید" row — a dashed-outline tap target (Flutter has no
/// built-in dashed [BorderSide], so it's painted manually to match the
/// handoff's `1.5px dashed #C9BB98` style).
class _DashedAddRow extends StatelessWidget {
  const _DashedAddRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedRRectPainter(color: AppColors.borderDashed, radius: 15),
          child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '+ افزودن ماده جدید',
              style: AppText.button(color: AppColors.inkSoft).copyWith(fontSize: 14.5, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius));
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length).toDouble()), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
