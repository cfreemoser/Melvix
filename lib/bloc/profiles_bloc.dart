import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/profile.dart';
import 'package:netflix_gallery/pages/profiles.dart';
import 'package:netflix_gallery/service/config_service.dart';

part 'profiles_event.dart';
part 'profiles_state.dart';

class ProfilesBloc extends Bloc<ProfilesEvent, ProfilesState> {
  final ConfigService _configService;

  ProfilesBloc(this._configService)
      : super(
            ProfilesInitial(profiles: _configService.getProfilesFromConfig())) {
    on<ProfileSelected>((event, emit) => emit(ProfileSelectedState()));
  }
}
