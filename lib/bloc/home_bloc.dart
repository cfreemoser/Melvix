import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/domain/content_ref.dart';
import 'package:netflix_gallery/service/firestore_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StorageService storageService;
  final FirestoreService firestoreService;
  final List<Content> topContent = [];
  final List<Content> featuredContent = [];
  final List<Content> friendsContent = [];
  final List<Content> stefanContent = [];
  final List<Content> allContent = [];

  HomeBloc(this.storageService, this.firestoreService) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<ErrorPageRequested>((event, emit) {
      emit(ErrorState());
    });
    on<ContentRequested>((event, emit) => loadContent(emit));

    firestoreService.subscribeToContent().listen((event) {
      add(ContentRequested());
    });
  }

  Future loadContent(Emitter<HomeState> emit) async {
    var contentRefs = await firestoreService.getAllContent();
    contentRefs?.shuffle();
    var awaitableContent = contentRefs?.map(mapContentRefToContent);
    if (awaitableContent != null) {
      for (var element in awaitableContent) {
        var content = await element;
        if (content != null) {
          if (allContent.contains(content) == false) {
            allContent.add(content);
            emit(AllContentUpdated(allContent));
          }
          if (content.categories.contains('top') &&
              topContent.contains(content) == false) {
            topContent.add(content);
            emit(TopContentUpdated(topContent));
          }
          if (content.categories.contains('featured') &&
              featuredContent.contains(content) == false) {
            featuredContent.add(content);
            emit(FeaturedContentUpdated(featuredContent));
          }
          if (content.categories.contains('friends') &&
              friendsContent.contains(content) == false) {
            friendsContent.add(content);
            emit(FriendsContentUpdated(friendsContent));
          }
          if (content.categories.contains('stefan_original') &&
              stefanContent.contains(content) == false) {
            stefanContent.add(content);
            emit(StefanContentUpdated(stefanContent));
          }
        }
      }
    }
  }

  Future<Content?> mapContentRefToContent(ContentRef ref) async {
    try {
      var videoURL =
          await storageService.getDownloadPathFromRef(ref.videoURLPath);
      var imageURL =
          await storageService.getDownloadPathFromRef(ref.headerImagePath);
      var titleSvgURL = ref.titleSvgPath != null
          ? await storageService.getDownloadPathFromRef(ref.titleSvgPath!)
          : null;
      if (videoURL == null || imageURL == null) {
        return null;
      }
      return Content(
          headerImageURL: imageURL,
          videoURL: videoURL,
          title: ref.title,
          titleSvgURL: titleSvgURL,
          description: ref.description,
          categories: ref.categories);
    } on StorageQuotaExceeded {
      add(ErrorPageRequested());
      return null;
    }
  }
}
