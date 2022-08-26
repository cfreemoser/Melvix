part of 'player_cubit.dart';

@immutable
abstract class PlayerState {}

class PlayerInitial extends PlayerState {}

class PlayerLandscapeMode extends PlayerState {}
class PlayerPortraitMode extends PlayerState {}
