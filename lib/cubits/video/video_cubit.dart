import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/content.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<Content?> {
  VideoCubit() : super(null);

  void setContent(Content content) => emit(content);
}
