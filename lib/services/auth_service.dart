import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String? _baseUrl = dotenv.env['API_URL'];
  String? _token;

  bool get isLoggedIn => _token != null;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/sign-in');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final token = data['data']['token'];

      _token = token;

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return data['data']; // return user + token
    } else {
      throw Exception(data['message'] ?? 'Sign-in failed');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/sign-up');
    final body = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phoneNumber,
      'position': role,
      'password': password,
    };
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

  Future<Map<String, dynamic>> getProfile() async {
    if (_token == null) throw Exception('Not authenticated');
    final url = Uri.parse('$_baseUrl/auth/me');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(data['message'] ?? 'Failed to load profile');
    }
  }

  String? get token => _token;
}

final authService = AuthService();
