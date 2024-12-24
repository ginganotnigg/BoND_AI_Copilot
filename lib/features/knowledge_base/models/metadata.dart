class Metadata {
  int limit;
  int total;
  int offset;
  bool hasNext;
  Metadata(
      {required this.limit,
      required this.total,
      required this.offset,
      required this.hasNext});
  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
        limit: json['limit'] ?? 0,
        total: json['total'] ?? 0,
        offset: json['offset'] ?? 0,
        hasNext: json['hasNext'] ?? false);
  }
}
