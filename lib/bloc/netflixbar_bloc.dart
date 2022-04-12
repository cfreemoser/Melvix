import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'netflixbar_event.dart';
part 'netflixbar_state.dart';

class NetflixbarBloc extends Bloc<NetflixbarEvent, NetflixbarState> {
  late bool isMobile;
  late double maxHeight;
  double offset = 0;

  NetflixbarBloc() : super(NetflixbarInitial()) {
    on<NetflixbarEvent>((event, emit) {});
    on<NetflixbarTopRequested>((event, emit) {
      emit(NetflxbarEnsureHomePage());
      emit(const NetflixbarOffsetRequested(offset: 0));
    });
    on<NetflixbarFriendsRequested>((event, emit) {
      emit(NetflxbarEnsureHomePage());
      emit(NetflixbarOffsetRequested(offset: maxHeight + 1));
    });
    on<NetflixbarHighlightsRequested>((event, emit) {
      emit(NetflxbarEnsureHomePage());
      emit(NetflixbarOffsetRequested(offset: maxHeight + 161));
    });
    on<NetflixbarAllRequested>((event, emit) {
      emit(NetflxbarEnsureHomePage());
      emit(NetflixbarOffsetRequested(offset: maxHeight + 660));
    });
    on<NetflixbarQuickLaughtersRequested>((event, emit) {
      emit(NetflixbarOffsetChanged(
          offset: offset, section: SelectedSection.quickLaughters));
    });
    on<NetflixbarScrollOffsetChanged>((event, emit) {
      offset = event.offset;
      emit(
          NetflixbarOffsetChanged(offset: offset, section: calculateSection()));
    });
    on<NetflixbarConstrainsChanged>((event, emit) {
      isMobile = event.mobile;
      maxHeight = event.maxHeight;
    });
  }

  SelectedSection calculateSection() {
    var topContentSectionHight = maxHeight;
    var familySectionHeight = 160;
    var highlightsSectionHeight = 500;
    var stefanOriginalSectionHeight = isMobile ? 180 : 0;
    var contentListSectionHeight = 180;

    if (isOffsetBetween(offset, 0, topContentSectionHight)) {
      return SelectedSection.top;
    } else if (isOffsetBetween(offset, topContentSectionHight,
        topContentSectionHight + familySectionHeight)) {
      return SelectedSection.friends;
    } else if (isOffsetBetween(
        offset,
        topContentSectionHight + familySectionHeight,
        topContentSectionHight +
            familySectionHeight +
            highlightsSectionHeight)) {
      return SelectedSection.highlights;
    } else if (isOffsetBetween(
        offset,
        topContentSectionHight + familySectionHeight + highlightsSectionHeight,
        topContentSectionHight +
            familySectionHeight +
            highlightsSectionHeight +
            stefanOriginalSectionHeight)) {
      return SelectedSection.stefanOriginals;
    } else if (isOffsetBetween(
        offset,
        topContentSectionHight +
            familySectionHeight +
            highlightsSectionHeight +
            stefanOriginalSectionHeight,
        topContentSectionHight +
            familySectionHeight +
            highlightsSectionHeight +
            stefanOriginalSectionHeight +
            contentListSectionHeight)) {
      return SelectedSection.library;
    } else {
      return SelectedSection.top;
    }
  }

  bool isOffsetBetween(double value, double min, double max) {
    return value >= min && value <= max;
  }
}
