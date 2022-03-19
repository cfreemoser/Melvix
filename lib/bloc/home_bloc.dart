import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/domain/content_ref.dart';
import 'package:netflix_gallery/service/config_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ConfigService configService;
  final StorageService storageService;

  HomeBloc(this.configService, this.storageService) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeRequestContent>((event, emit) async {
      emit(await loadContent());
    });
  }

  Future<HighlightsLoaded> loadContent() async {
    var contentRefs = configService.getFeaturedContentFromConfig();
    var resolvedContent = contentRefs.map(mapContentRefToContent);
    var featuredContent = await Future.wait(resolvedContent).then(
        (value) => value.where((element) => element != null).map((e) => e!));
    return HighlightsLoaded(featuredContent.toList());
  }

  Future<Content?> mapContentRefToContent(ContentRef ref) async {
    var videoURL =
        await storageService.getDownloadPathFromRef(ref.videoURLPath);
    var imageURL =
        await storageService.getDownloadPathFromRef(ref.headerImagePath);
    var title = ref.title;
    if (videoURL == null || imageURL == null) {
      return null;
    }
    return Content(headerImageURL: imageURL, videoURL: videoURL, title: title);
  }
}
