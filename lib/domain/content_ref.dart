class ContentRef {
  final String headerImagePath;
  final String videoURLPath;
  final String title;
  final List<String> categories;

  ContentRef(
      {required this.headerImagePath,
      required this.videoURLPath,
      required this.title,
      this.categories = const []});
}
