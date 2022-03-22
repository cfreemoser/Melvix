import 'package:netflix_gallery/helpers/constants.dart';

class QuickContent {
  String contentUrl;
  QuickContentType type;

  QuickContent(
      {this.contentUrl = Constants.content_cover_image,
      this.type = QuickContentType.photo});
}

enum QuickContentType {
  video,
  photo,
}
