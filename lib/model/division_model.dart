class DivisionModel {
  final dynamic id;
  final String name;
  final String type;
  final String? parentId;

  DivisionModel({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"],
      type: json["type"],
      parentId: json["parentId"].toString(),
    );
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivisionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
