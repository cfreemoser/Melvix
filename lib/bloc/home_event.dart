part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class ContentRequested extends HomeEvent {}

class ErrorPageRequested extends HomeEvent {}