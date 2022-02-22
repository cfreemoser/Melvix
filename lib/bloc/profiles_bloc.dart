import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/profile.dart';
import 'package:netflix_gallery/service/config_service.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  final ConfigService _configService;

  ProfilesBloc(this._configService)
      : super(
            ProfilesInitial(profiles: _configService.getProfilesFromConfig())) {
    on<ProfileSelected>(
        (event, emit) => emit(_mapProfileSelectedToState(event)));

    on<ProfilePinEntered>((event, emit) => log("pin correct!"));
  }

  _mapProfileSelectedToState(ProfileSelected event) {
    if (event.selectedProfile.profilePin != null) {
      return PinSecuredProfileSelected(event.selectedProfile);
    } else {
      return FakeProfileSelected();
    }
  }
}
