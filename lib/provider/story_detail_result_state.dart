import 'package:declarative_navigation/model/story.dart';

sealed class StoryDetailResultState {}

// todo-01-state-04: expand the result for non, loading, loaded, and error state
class StoryDetailNoneState extends StoryDetailResultState {}

class StoryDetailLoadingState extends StoryDetailResultState {}

class StoryDetailErrorState extends StoryDetailResultState {
  final String error;

  StoryDetailErrorState(this.error);
}

class StoryDetailLoadedState extends StoryDetailResultState {
  final Story data;

  StoryDetailLoadedState(this.data);
}
