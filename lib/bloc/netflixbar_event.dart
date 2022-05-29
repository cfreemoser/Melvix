part of 'netflixbar_bloc.dart';

abstract class NetflixbarEvent extends Equatable {
  const NetflixbarEvent();

  @override
  List<Object> get props => [];
}

class NetflixbarScrollOffsetChanged extends NetflixbarEvent {
  final double offset;

  const NetflixbarScrollOffsetChanged({required this.offset});

  @override
  List<Object> get props => [offset];
}

class NetflixbarConstrainsChanged extends NetflixbarEvent {
  final bool mobile;
  final double maxHeight;

  const NetflixbarConstrainsChanged(
      {required this.mobile, required this.maxHeight});

  @override
  List<Object> get props => [mobile, maxHeight];
}

class NetflixbarQuickLaughtersRequested extends NetflixbarEvent {
  const NetflixbarQuickLaughtersRequested();
}

class NetflixbarUploadRequested extends NetflixbarEvent {
  const NetflixbarUploadRequested();
}

class NetflixbarTopRequested extends NetflixbarEvent {
  const NetflixbarTopRequested();
}

class NetflixbarFriendsRequested extends NetflixbarEvent {
  const NetflixbarFriendsRequested();
}

class NetflixbarHighlightsRequested extends NetflixbarEvent {
  const NetflixbarHighlightsRequested();
}

class NetflixbarAllRequested extends NetflixbarEvent {
  const NetflixbarAllRequested();
}