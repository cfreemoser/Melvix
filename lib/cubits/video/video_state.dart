part of 'video_cubit.dart';

@immutable
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoPersisted extends VideoState {
  final Content content;

  VideoPersisted(this.content);
}
