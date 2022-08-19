class ContentRef {
  final String bucket;
  final String videoURLPath;
  final String title;
  final String description;
  final String? titleSvgPath;
  final List<String> categories;

  ContentRef(
      {required this.bucket,
      required this.videoURLPath,
      required this.title,
      required this.description,
      required this.titleSvgPath,
      this.categories = const []});
}
