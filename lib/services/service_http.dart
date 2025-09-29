import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceHttp {
  final String baseUrl = 'https://your-laravel-api.com/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> fetchPapers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/papers'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load papers');
    }
  }

  Future<Map<String, dynamic>> fetchPaperDetail(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/papers/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load paper detail');
    }
  }
}
