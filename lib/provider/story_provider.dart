import 'dart:typed_data';

import 'package:declarative_navigation/model/upload_response.dart';
import 'package:declarative_navigation/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;

  StoryProvider(this.apiService);

  bool isUploading = false;
  String message = '';
  UploadResponse? uploadResponse;
  final String tokenKey = 'token';

  Future<void> uploadStory({
    required List<int> bytes,
    required String fileName,
    required String description,
    double? lat,
    double? lon,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception('User not logged in');
      }

      message = '';
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      uploadResponse = await apiService.uploadStory(
        bytes: bytes,
        fileName: fileName,
        description: description,
        lat: lat,
        lon: lon,
        token: token,
      );

      message = uploadResponse?.message ?? 'success';
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      newByte = img.encodeJpg(image, quality: compressQuality);

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }
}
