import 'package:declarative_navigation/model/list_story.dart';

class ListStoryResponse {
  final bool error;
  final String message;
  final List<ListStory> listStory;

  ListStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) {
    return ListStoryResponse(
      error: json['error'],
      message: json['message'],
      listStory:
          json['listStory'] != null
              ? List<ListStory>.from(
                json['listStory']!.map((x) => ListStory.fromJson(x)),
              )
              : <ListStory>[],
    );
  }
}
