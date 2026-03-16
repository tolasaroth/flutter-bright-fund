import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryItem {
  final String id;
  final String name;

  const CategoryItem({required this.id, required this.name});
}

class CategoryService {
  final String? _baseUrl = dotenv.env['API_URL'];

  Future<List<CategoryItem>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Supports both `{ success, data: [...] }` and legacy `[...]` payloads.
      final List<dynamic> list = decoded is Map<String, dynamic>
          ? (decoded['data'] as List<dynamic>? ?? const [])
          : (decoded as List<dynamic>);

      return list
          .map(
            (item) => CategoryItem(
              id: (item['id'] ?? '').toString(),
              name: (item['name'] ?? '').toString(),
            ),
          )
          .where((c) => c.id.isNotEmpty && c.name.trim().isNotEmpty)
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

final categoryService = CategoryService();
