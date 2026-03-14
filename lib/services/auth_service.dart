import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String? _baseUrl = dotenv.env['API_URL'];
  String? _token;

  bool get isLoggedIn => _token != null;

  // Load token from storage when app starts
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _token = data['token'];
      // Save token in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      return data;
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    String? profileImage,
    List<String> rolesRequest = const [],
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    final body = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'confirmPassword': confirmPassword,
      'rolesRequest': rolesRequest,
    };
    if (profileImage != null && profileImage.isNotEmpty) {
      body['profileImage'] = profileImage;
    }
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  String? get token => _token;
}

final authService = AuthService();
