/// A searchable ingredient suggestion returned by `/ingredients/search`.
class Ingredient {
  const Ingredient({required this.id, required this.name});

  final String id;
  final String name;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(id: '${json['id']}', name: json['name'] as String);
  }
}
