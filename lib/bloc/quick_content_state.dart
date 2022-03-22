part of 'quick_content_bloc.dart';

abstract class QuickContentState extends Equatable {
  const QuickContentState();

  @override
  List<Object> get props => [];
}

class QuickContentInitial extends QuickContentState {}

class QuickContentLoaded extends QuickContentState {
  final List<QuickContent> quickContents;

  const QuickContentLoaded(this.quickContents);
}

class QuickContentError extends QuickContentState {
  const QuickContentError();
}
