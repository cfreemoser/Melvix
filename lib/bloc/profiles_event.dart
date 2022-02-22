part of 'profiles_bloc.dart';

@immutable
abstract class ProfilesEvent {}

class ProfileSelected extends ProfilesEvent {
  final Profile selectedProfile;

  ProfileSelected(this.selectedProfile);
}

class ProfilePinEntered extends ProfilesEvent {
  final Profile selectedProfile;

  ProfilePinEntered(this.selectedProfile);
}
