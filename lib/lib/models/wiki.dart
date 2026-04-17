class Wiki {
  Wiki({
    required this.pageId,
    required this.title,
    required this.extract,
    this.imageUrl,
  });
  final String pageId;
  final String title;
  final String? imageUrl;
  final String extract;
}
