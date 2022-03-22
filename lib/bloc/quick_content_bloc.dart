import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:netflix_gallery/domain/quick_content.dart';
import 'package:netflix_gallery/service/config_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';

part 'quick_content_event.dart';
part 'quick_content_state.dart';

class QuickContentBloc extends Bloc<QuickContentEvent, QuickContentState> {
  final ConfigService configService;
  final StorageService storageService;

  QuickContentBloc(this.configService, this.storageService)
      : super(QuickContentInitial()) {
    on<QuickContentRequested>((event, emit) async {
      emit(await loadQuickContent());
    });
  }

  Future<QuickContentState> loadQuickContent() async {
    var contentRef = configService.getQuickContentRef();
    var quickContents = await storageService
        .getDownloadAllDownloadPathsFromFolderRef(contentRef.storagePath);
    if (quickContents == null) {
      return const QuickContentError();
    }
    var result = quickContents
        .where((e) => e != null)
        .map((e) => QuickContent(contentUrl: e!))
        .toList();
    return QuickContentLoaded(result);
  }
}
