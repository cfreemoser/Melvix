part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HighlightsRequested extends HomeEvent {}

class TopRequested extends HomeEvent {}