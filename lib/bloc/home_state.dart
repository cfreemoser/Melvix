part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HighlightsLoaded extends HomeState {
  final List<Content> featuredContent;

  HighlightsLoaded(this.featuredContent);
}

class TopLoaded extends HomeState {
  final List<Content> topContent;

  TopLoaded(this.topContent);
}

class ErrorState extends HomeState {}

class ContentLoaded extends HomeState {
  final List<Content> topContent;
  final List<Content> featuredContent;
  final List<Content> friendsContent;
  final List<Content> stefanContent;

  final List<Content> allContent;

  ContentLoaded(this.topContent, this.featuredContent, this.friendsContent,
      this.stefanContent, this.allContent);
}
