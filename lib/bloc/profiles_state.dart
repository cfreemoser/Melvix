part of 'profiles_bloc.dart';

@immutable
abstract class ProfilesState {}

class ProfilesInitial extends ProfilesState {
  List<Profile> profiles;

  ProfilesInitial({required this.profiles});
}
