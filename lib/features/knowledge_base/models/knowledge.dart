class Knowledge {
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  String updatedBy;
  String userId;
  String title;
  String description;
  String id;
  int numberUnits;
  int totalSize;
  Knowledge(
      {required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy,
      required this.userId,
      required this.title,
      required this.description,
      required this.id,
      required this.numberUnits,
      required this.totalSize});
  factory Knowledge.fromJson(Map<String, dynamic> json) {
    return Knowledge(
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdBy: json['createdBy'] ?? 'Default',
      updatedBy: json['updatedBy'] ?? 'Default',
      userId: json['userId'] ?? 'Default',
      title: json['knowledgeName'] ?? 'Default',
      description: json['description'] ?? 'Default',
      id: json['id'] ?? 'Default',
      numberUnits: json['numUnits'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
    );
  }
}
