import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netflix_gallery/domain/content.dart';
import 'package:netflix_gallery/domain/content_ref.dart';
import 'package:netflix_gallery/service/firestore_service.dart';
import 'package:netflix_gallery/service/storage_service.dart';
import 'package:collection/collection.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StorageService storageService;
  final FirestoreService firestoreService;
  final Set<Content> topContent = {};
  final Set<Content> featuredContent = {};
  final Set<Content> friendsContent = {};
  final Set<Content> stefanContent = {};
  final Set<Content> allContent = {};

  List<ContentRef>? cachedRefs = [];

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
    Function eq = const ListEquality().equals;
    var contentRefs = await firestoreService.getAllContent();
    if (eq(cachedRefs, contentRefs)) {
      if (allContent.isNotEmpty) {
        emit(AllContentUpdated(allContent.toList()));
      }
      if (topContent.isNotEmpty) {
        emit(TopContentUpdated(topContent.toList()));
      }
      if (friendsContent.isNotEmpty) {
        emit(FriendsContentUpdated(friendsContent.toList()));
      }
      if (stefanContent.isNotEmpty) {
        emit(StefanContentUpdated(stefanContent.toList()));
      }

      return;
    }
    
    cachedRefs = contentRefs;
    contentRefs?.shuffle();
    var awaitableContents = contentRefs?.map(mapContentRefToContent);

    if (awaitableContents == null) {
      return;
    }

    for (var awaitableContent in awaitableContents) {
      var content = await awaitableContent;
      await addToCategory(content, emit);
    }
  }

  Future addToCategory(Content? content, Emitter<HomeState> emit) async {
    if (content == null) {
      return;
    }

    for (var category in content.categories) {
      allContent.add(content);
      emit(AllContentUpdated(allContent.toList()));
      switch (category) {
        case "top":
          topContent.add(content);
          emit(TopContentUpdated(topContent.toList()));
          continue;
        case "featured":
          featuredContent.add(content);
          emit(FeaturedContentUpdated(topContent.toList()));
          continue;
        case "friends":
          friendsContent.add(content);
          emit(FriendsContentUpdated(friendsContent.toList()));
          continue;
        case "stefan_original":
          stefanContent.add(content);
          emit(StefanContentUpdated(stefanContent.toList()));
          continue;
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
