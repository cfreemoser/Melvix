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
  final StorageService storageService;
  final FirestoreService firestoreService;

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
    var awaitableContent = contentRefs?.map(mapContentRefToContent);
    if (awaitableContent != null) {
      var maybeContent = await Future.wait(awaitableContent);
      var content = maybeContent
          .where((element) => element != null)
          .map((e) => e!)
          .toList();

      content.shuffle();

      var topContent = content
          .where((element) => element.categories.contains('top'))
          .toList();
      var featuredContent = content
          .where((element) => element.categories.contains('featured'))
          .toList();
      var friendsContent = content
          .where((element) => element.categories.contains('friends'))
          .toList();
      emit(ContentLoaded(topContent, featuredContent, friendsContent, content));
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
      var title = ref.title;
      if (videoURL == null || imageURL == null) {
        return null;
      }
      return Content(
          headerImageURL: imageURL,
          videoURL: videoURL,
          title: title,
          titleSvgURL: titleSvgURL,
          categories: ref.categories);
    } on StorageQuotaExceeded {
      add(ErrorPageRequested());
      return null;
    }
  }
}
