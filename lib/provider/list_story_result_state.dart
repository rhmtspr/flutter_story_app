import 'package:declarative_navigation/model/list_story.dart';

sealed class ListStoryResultState {}

class ListStoryNoneState extends ListStoryResultState {}

class ListStoryLoadingState extends ListStoryResultState {}

class ListStoryErrorState extends ListStoryResultState {
  final String error;

  ListStoryErrorState(this.error);
}

class ListStoryLoadedState extends ListStoryResultState {
  final List<ListStory> data;

  ListStoryLoadedState(this.data);
}
