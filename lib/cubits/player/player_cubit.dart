import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit({required bool landscape})
      : super(landscape ? PlayerLandscapeMode() : PlayerPortraitMode());

  void setLandscape() => emit(PlayerLandscapeMode());
  void setPortrait() => emit(PlayerPortraitMode());

  
}
