import 'package:netflix_gallery/helpers/constants.dart';

class Content {
  final String headerImageURL;
  final String videoURL =
      "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4";
  final String title;

  Content(
      {this.headerImageURL = Constants.content_cover_image,
      this.title = "TITLE"});
}