import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const baseUrl = "https://story-api.dicoding.dev/v1";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && !data["error"]) {
      return data["loginResult"];
    } else {
      throw Exception(data["message"]);
    }
  }
}
