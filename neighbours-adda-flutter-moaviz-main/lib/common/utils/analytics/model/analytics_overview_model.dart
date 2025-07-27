class AnalyticsOverviewModel {
  final String id;
  final String name;
  final num value;
  final bool isGraphAvailable;

  const AnalyticsOverviewModel({
    required this.id,
    required this.name,
    required this.value,
    required this.isGraphAvailable,
  });

  //from json
  factory AnalyticsOverviewModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverviewModel(
      id: json['id'].toString(),
      name: json['name'],
      value: num.parse(json['value'].toString()),
      isGraphAvailable: json['is_graph_available'],
    );
  }
}
