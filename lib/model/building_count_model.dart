
class BuildingCountModel {
  final String buildName;
  final int count;

  BuildingCountModel({
    required this.buildName,
    required this.count,
  });

  factory BuildingCountModel.fromJson(Map<String, dynamic> json) {
    return BuildingCountModel(
      buildName: json['buildName'] ?? "",
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildName': buildName,
      'count': count,
    };
  }
}
