import 'dart:io';

import 'package:declarative_navigation/provider/story_detail_result_state.dart';
import 'package:declarative_navigation/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryDetailProvider extends ChangeNotifier {
  final String tokenKey = 'token';
  final ApiService _apiService;
  StoryDetailProvider(this._apiService);
  StoryDetailResultState _resultState = StoryDetailNoneState();
  StoryDetailResultState get resultState => _resultState;

  Future<void> fetchStoryDetail(String id) async {
    try {
      _resultState = StoryDetailLoadingState();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception('User not logged in');
      }

      final result = await _apiService.getStoryDetail(id, token);

      if (result.error) {
        _resultState = StoryDetailErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = StoryDetailLoadedState(result.story);
        notifyListeners();
      }
    } on SocketException {
      _resultState = StoryDetailErrorState(
        'There is no internet connection. Please check your WI-FI or mobile data.',
      );
      notifyListeners();
    } on Exception catch (e) {
      _resultState = StoryDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
