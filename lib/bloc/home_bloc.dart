import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/domain/content_ref.dart';
import 'package:netflix_gallery/service/config_service.dart';
import 'package:netflix_gallery/service/firestore_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ConfigService configService;
  final StorageService storageService;
  final FirestoreService firestoreService;

  HomeBloc(this.configService, this.storageService, this.firestoreService)
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<ContentRequested>((event, emit) => loadContent(emit));

    firestoreService.subscribeToContent().listen((event) {
      add(ContentRequested());
    });
  }

  Future loadContent(Emitter<HomeState> emit) async {
    var contentRefs = await firestoreService.getAllContent();
    var awaitableContent = contentRefs?.map(mapContentRefToContent);
    if (awaitableContent != null) {
      var maybeContent = await Future.wait(awaitableContent);
      var content = maybeContent
          .where((element) => element != null)
          .map((e) => e!)
          .toList();
      var topContent = content
          .where((element) => element.categories.contains('top'))
          .toList();
      var featuredContent = content
          .where((element) => element.categories.contains('featured'))
          .toList();
      topContent.shuffle();
      featuredContent.shuffle();
      content.shuffle();
      emit(ContentLoaded(topContent, featuredContent, content));
    }
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
    return Content(
        headerImageURL: imageURL,
        videoURL: videoURL,
        title: title,
        categories: ref.categories);
  }
}
