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

class ContentLoaded extends HomeState {
  final List<Content> topContent;
  final List<Content> featuredContent;
  final List<Content> allContent;

  ContentLoaded(this.topContent, this.featuredContent, this.allContent);
}
