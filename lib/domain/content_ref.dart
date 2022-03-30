class ContentRef {
  final String headerImagePath;
  final String videoURLPath;
  final String title;
  final String? titleSvgPath;
  final List<String> categories;

  ContentRef(
      {required this.headerImagePath,
      required this.videoURLPath,
      required this.title,
      required this.titleSvgPath,
      this.categories = const []});
}
