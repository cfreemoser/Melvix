part of 'quick_content_bloc.dart';

abstract class QuickContentEvent extends Equatable {
  const QuickContentEvent();

  @override
  List<Object> get props => [];
}

class QuickContentRequested extends QuickContentEvent {
  const QuickContentRequested();

  @override
  List<Object> get props => [];
}
