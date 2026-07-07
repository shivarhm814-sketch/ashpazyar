/// A single ingredient the user has already added to their pantry.
class PantryItem {
  const PantryItem({required this.id, required this.name});

  final String id;
  final String name;

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(id: '${json['id']}', name: json['name'] as String);
  }
}
