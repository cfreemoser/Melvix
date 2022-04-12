part of 'netflixbar_bloc.dart';

abstract class NetflixbarState extends Equatable {
  const NetflixbarState();

  @override
  List<Object> get props => [];
}

class NetflixbarInitial extends NetflixbarState {}

class NetflixbarOffsetChanged extends NetflixbarState {
  final double offset;
  final SelectedSection section;

  const NetflixbarOffsetChanged({required this.offset, required this.section});

  @override
  List<Object> get props => [offset, section];
}

class NetflixbarOffsetRequested extends NetflixbarState {
  final double offset;

  const NetflixbarOffsetRequested({required this.offset});

  @override
  List<Object> get props => [offset];
}

class NetflxbarEnsureHomePage extends NetflixbarState {}

enum SelectedSection {
  top,
  friends,
  highlights,
  stefanOriginals,
  library,
  quickLaughters
}
