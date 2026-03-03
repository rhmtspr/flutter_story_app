import 'package:declarative_navigation/provider/list_story_result_state.dart';
import 'package:declarative_navigation/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListStoryProvider extends ChangeNotifier {
  final String tokenKey = 'token';
  final ApiService _apiService;
  ListStoryProvider(this._apiService);
  ListStoryResultState _resultState = ListStoryNoneState();
  ListStoryResultState get resultState => _resultState;

  Future<void> fetchListStory() async {
    try {
      _resultState = ListStoryLoadingState();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);

      if (token == null) {
        throw Exception('User not logged in');
      }

      final result = await _apiService.getListStory(token);

      if (result.error) {
        _resultState = ListStoryErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = ListStoryLoadedState(result.listStory);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = ListStoryErrorState(e.toString());
      notifyListeners();
    }
  }
}
