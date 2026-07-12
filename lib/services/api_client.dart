import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.get(uri);
    return _parseResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return _parseResponse(response);
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    final json = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json as Map<String, dynamic>;
    }
    throw Exception('API error: ${response.statusCode} ${response.body}');
  }
}
