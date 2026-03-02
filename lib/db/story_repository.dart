// import 'package:declarative_navigation/model/upload_response.dart';
// import 'package:declarative_navigation/services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StoryRepository {
//   final ApiService apiService;

//   StoryRepository(this.apiService);

//   final String tokenKey = 'token';

//   Future<bool> uploadStory({
//     required List<int> bytes,
//     required String fileName,
//     required String description,
//     double? lat,
//     double? lon,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(tokenKey);

//     if (token == null) {
//       throw Exception("User not logged in");
//     }

//     await apiService.uploadStory(
//       bytes: bytes,
//       fileName: fileName,
//       description: description,
//       token: token,
//       lat: lat,
//       lon: lon,
//     );
//   }
// }
