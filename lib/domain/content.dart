import 'package:equatable/equatable.dart';
import 'package:netflix_gallery/helpers/constants.dart';

class Content extends Equatable {
  final String headerImageURL;
  final String videoURL;
  final String title;
  final String? titleSvgURL;
  final List<String> categories;
  final String description;

  @override
  List<Object> get props => [headerImageURL, videoURL, title];

  const Content(
      {this.headerImageURL = Constants.content_cover_image,
      this.titleSvgURL,
      this.description = "",
      this.videoURL =
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      this.title = "TITLE",
      this.categories = const []});
}
