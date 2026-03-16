import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignService {
  final String _baseUrl = "http://localhost:3000/api/campaigns";

  String? _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Map<String, String> _headers({bool auth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (auth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> getCampaigns({
    int page = 1,
    int limit = 10,
    String? status,
    String? categoryId,
    String? search,
  }) async {
    final uri = Uri.parse(
      "$_baseUrl?page=$page&limit=$limit&status=${status ?? ''}&category_id=${categoryId ?? ''}&search=${search ?? ''}",
    );

    final res = await http.get(uri, headers: _headers());

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> getCampaign(String id) async {
    final uri = Uri.parse("$_baseUrl/$id");

    final res = await http.get(uri, headers: _headers());

    return jsonDecode(res.body);
  }

  // FIX: added currentAmount parameter so the validated field is actually sent
  Future<Map<String, dynamic>> createCampaign({
    required String title,
    required double goalAmount,
    double? currentAmount, // FIX: new param
    String? description,
    String? categoryId,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    await loadToken();

    final uri = Uri.parse(_baseUrl);

    final res = await http.post(
      uri,
      headers: _headers(auth: true),
      body: jsonEncode({
        "title": title,
        "goal_amount": goalAmount,
        // FIX: include current_amount when provided
        if (currentAmount != null) "current_amount": currentAmount,
        "description": description,
        "category_id": categoryId,
        "start_date": startDate,
        "end_date": endDate,
        // FIX: status was missing from the original; now always sent
        if (status != null) "status": status,
      }),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode != 201 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to create campaign');
    }

    return body['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateCampaign(
    String id, {
    String? title,
    String? description,
    double? goalAmount,
    String? categoryId,
    String? status,
  }) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$id");

    final res = await http.put(
      uri,
      headers: _headers(auth: true),
      body: jsonEncode({
        "title": title,
        "description": description,
        "goal_amount": goalAmount,
        "category_id": categoryId,
        "status": status,
      }),
    );

    return jsonDecode(res.body);
  }

  Future<bool> deleteCampaign(String id) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$id");

    final res = await http.delete(uri, headers: _headers(auth: true));

    return res.statusCode == 200;
  }

  /// Upload cover image directly from bytes — avoids path_provider / temp files.
  Future<Map<String, dynamic>> uploadImageBytes(
    String campaignId,
    Uint8List bytes,
    String filename,
  ) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$campaignId/images");

    final request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $_token';

    final ext = filename.split('.').last.toLowerCase();
    final mime = const {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
    }[ext] ?? 'image/jpeg';

    request.files.add(
      http.MultipartFile.fromBytes(
        "images",
        bytes,
        filename: filename,
        contentType: MediaType.parse(mime),
      ),
    );

    final res = await request.send();
    final body = await res.stream.bytesToString();

    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> uploadImages(
    String campaignId,
    List<File> images,
  ) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$campaignId/images");

    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $_token';

    for (var img in images) {
      request.files.add(await http.MultipartFile.fromPath("images", img.path));
    }

    final res = await request.send();
    final body = await res.stream.bytesToString();

    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<bool> deleteImage(String campaignId, String imageId) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$campaignId/images/$imageId");

    final res = await http.delete(uri, headers: _headers(auth: true));

    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>> uploadDocuments(
    String campaignId,
    List<File> docs,
  ) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$campaignId/documents");

    final request = http.MultipartRequest("POST", uri);

    request.headers['Authorization'] = 'Bearer $_token';

    for (var doc in docs) {
      request.files.add(
        await http.MultipartFile.fromPath("documents", doc.path),
      );
    }

    final res = await request.send();
    final body = await res.stream.bytesToString();

    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<bool> deleteDocument(String campaignId, String docId) async {
    await loadToken();

    final uri = Uri.parse("$_baseUrl/$campaignId/documents/$docId");

    final res = await http.delete(uri, headers: _headers(auth: true));

    return res.statusCode == 200;
  }
}
