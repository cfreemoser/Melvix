import 'package:netflix_gallery/helpers/constants.dart';

class Content {
  final String headerImageURL;
  final String videoURL;
  final String title;
  final String? titleSvgURL;
  final List<String> categories;

  @override
  List<Object> get props => [headerImageURL, videoURL, title];

  Content(
      {this.headerImageURL = Constants.content_cover_image,
      this.titleSvgURL = null,
      this.videoURL =
          "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
      this.title = "TITLE",
      this.categories = const []});
}
