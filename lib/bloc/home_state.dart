part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HighlightsLoaded extends HomeState {
  final List<Content> featuredContent;

  HighlightsLoaded(this.featuredContent);
}
