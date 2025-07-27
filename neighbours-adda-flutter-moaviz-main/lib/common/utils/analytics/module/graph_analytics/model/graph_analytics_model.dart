class GraphAnalyticsModel {
  final String x;
  final num y;

  GraphAnalyticsModel({
    required this.x,
    required this.y,
  });

  //from map
  factory GraphAnalyticsModel.fromMap(Map<String, dynamic> map) {
    return GraphAnalyticsModel(
      x: map['x'],
      y: num.parse(map['y'].toString()),
    );
  }
}
