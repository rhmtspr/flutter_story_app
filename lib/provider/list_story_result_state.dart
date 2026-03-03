import 'package:declarative_navigation/model/story.dart';

sealed class ListStoryResultState {}

class ListStoryNoneState extends ListStoryResultState {}

class ListStoryLoadingState extends ListStoryResultState {}

class ListStoryErrorState extends ListStoryResultState {
  final String error;

  ListStoryErrorState(this.error);
}

class ListStoryLoadedState extends ListStoryResultState {
  final List<Story> data;

  ListStoryLoadedState(this.data);
}
