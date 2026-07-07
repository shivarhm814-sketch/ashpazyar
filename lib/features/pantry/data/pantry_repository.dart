import '../../../core/network/api_client.dart';
import 'models/ingredient.dart';
import 'models/pantry_item.dart';

/// Backs the Pantry screen and the Add Ingredient sheet against the existing
/// FastAPI pantry/ingredient endpoints.
class PantryRepository {
  PantryRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<PantryItem>> fetchItems() async {
    final response = await _apiClient.get('/pantry/items');
    return (response as List).map((e) => PantryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PantryItem> addItem(String name) async {
    final response = await _apiClient.post('/pantry/items', body: {'name': name});
    return PantryItem.fromJson(response as Map<String, dynamic>);
  }

  Future<void> removeItem(String id) => _apiClient.delete('/pantry/items/$id');

  Future<List<Ingredient>> searchIngredients(String query) async {
    final response = await _apiClient.get('/ingredients/search', query: {'q': query});
    return (response as List).map((e) => Ingredient.fromJson(e as Map<String, dynamic>)).toList();
  }
}
