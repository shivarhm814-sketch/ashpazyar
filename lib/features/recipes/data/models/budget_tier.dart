/// The 3 extra-spend tiers offered on the Budget Selection screen.
enum BudgetTier {
  low('low', 'خیلی کم', 'فقط با چیزی که الان توی قفسه‌ته'),
  mid('mid', 'متوسط', 'می‌تونی یکی دو تا ماده‌ی کوچیک هم بخری'),
  open('open', 'بدون محدودیت', 'هر چی لازم باشه، بخر');

  const BudgetTier(this.id, this.label, this.description);

  final String id;
  final String label;
  final String description;
}
