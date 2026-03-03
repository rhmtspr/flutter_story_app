import 'dart:convert';
import 'package:declarative_navigation/model/list_story_response.dart';
import 'package:declarative_navigation/model/story_detail_response.dart';
import 'package:declarative_navigation/model/upload_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  /// =========================
  /// REGISTER
  /// =========================
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (data['error']) {
      throw Exception(data['message']);
    }
  }

  /// =========================
  /// LOGIN
  /// =========================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (data['error']) {
      throw Exception(data['message']);
    }

    return data['loginResult']; // contains id, name, token
  }

  /// =========================
  /// UPLOAD STORY
  /// =========================
  Future<UploadResponse> uploadStory({
    required List<int> bytes,
    required String fileName,
    required String description,
    required String token,
    double? lat,
    double? lon,
  }) async {
    final uri = Uri.parse('$baseUrl/stories');

    final request = http.MultipartRequest('POST', uri);

    /// Add Authorization Header ✅
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    /// Add fields
    request.fields['description'] = description;

    if (lat != null) {
      request.fields['lat'] = lat.toString();
    }

    if (lon != null) {
      request.fields['lon'] = lon.toString();
    }

    /// Add file
    request.files.add(
      http.MultipartFile.fromBytes('photo', bytes, filename: fileName),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final uploadResponse = UploadResponse.fromJson(response.body);

    if (response.statusCode != 201 || uploadResponse.error) {
      throw Exception(uploadResponse.message);
    }

    return uploadResponse;
  }

  /// =========================
  /// GET ALL STORIES
  /// =========================
  Future<ListStoryResponse> getListStory(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return ListStoryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load story list.');
    }
  }

  /// =========================
  /// GET STORY DETAIL
  /// =========================
  Future<StoryDetailResponse> getStoryDetail(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load the story detail');
    }
  }
}
