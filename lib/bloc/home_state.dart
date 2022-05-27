part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

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

class TopContentUpdated extends HomeState {
  final List<Content> topContent;

  TopContentUpdated(this.topContent);
}

class FeaturedContentUpdated extends HomeState {
  final List<Content> featuredContent;

  FeaturedContentUpdated(this.featuredContent);
}

class FriendsContentUpdated extends HomeState {
  final List<Content> friendsContent;

  FriendsContentUpdated(this.friendsContent);
}

class StefanContentUpdated extends HomeState {
  final List<Content> stefanContent;

  StefanContentUpdated(this.stefanContent);
}

class AllContentUpdated extends HomeState {
  final List<Content> allContent;

  AllContentUpdated(this.allContent);
}