import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/ingredient.dart';
import '../../data/pantry_repository.dart';

/// The "چی توی خونه داری؟" bottom sheet. Suggestions come live from
/// `/ingredients/search` (debounced), already-added pantry items are
/// excluded, and tapping a chip or the primary button adds the item.
class AddIngredientSheet extends StatefulWidget {
  const AddIngredientSheet({
    super.key,
    required this.pantryRepository,
    required this.existingItemNames,
    required this.onAdd,
  });

  final PantryRepository pantryRepository;
  final Set<String> existingItemNames;
  final Future<void> Function(String name) onAdd;

  static Future<void> show(
    BuildContext context, {
    required PantryRepository pantryRepository,
    required Set<String> existingItemNames,
    required Future<void> Function(String name) onAdd,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddIngredientSheet(
        pantryRepository: pantryRepository,
        existingItemNames: existingItemNames,
        onAdd: onAdd,
      ),
    );
  }

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  final _queryController = TextEditingController();
  Timer? _debounce;
  List<Ingredient> _suggestions = const [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _queryController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(value));
  }

  Future<void> _search(String query) async {
    try {
      final results = await widget.pantryRepository.searchIngredients(query);
      if (!mounted) return;
      setState(() {
        _suggestions = results.where((i) => !widget.existingItemNames.contains(i.name)).take(8).toList();
      });
    } catch (_) {
      // Keep the sheet usable even if suggestions fail to load.
    }
  }

  Future<void> _addAndClose(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      await widget.onAdd(trimmed);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text('چی توی خونه داری؟', style: AppText.cardTitle().copyWith(fontSize: 17)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _queryController,
                autofocus: true,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                onChanged: _onQueryChanged,
                onSubmitted: _addAndClose,
                style: AppText.body(),
                decoration: InputDecoration(
                  hintText: 'مثلا: پیاز، سیب‌زمینی...',
                  hintStyle: AppText.body(color: AppColors.captionMuted),
                  filled: true,
                  fillColor: AppColors.appBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    borderSide: const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    borderSide: const BorderSide(color: AppColors.turmeric, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 190),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions
                        .map((s) => GestureDetector(
                              onTap: () => _addAndClose(s.name),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  color: AppColors.chipBackground,
                                  borderRadius: BorderRadius.circular(AppRadius.pill),
                                ),
                                child: Text(s.name, style: AppText.chip()),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _submitting ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control)),
                        ),
                        child: Text('بستن', style: AppText.button(color: AppColors.inkSoft)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : () => _addAndClose(_queryController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.olive,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.control)),
                          elevation: 0,
                        ),
                        child: Text(
                          'اضافه شد!',
                          style: AppText.button(color: AppColors.surface).copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
