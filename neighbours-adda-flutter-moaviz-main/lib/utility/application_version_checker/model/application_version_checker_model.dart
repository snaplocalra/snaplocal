class ApplicationVersionCheckerModel {
  ApplicationVersionCheckerModel({
    required this.downloadLink,
    required this.latestVersion,
    required this.isCriticalUpdateRequired,
  });

  final String downloadLink;
  final String latestVersion;
  final bool isCriticalUpdateRequired;

  factory ApplicationVersionCheckerModel.fromMap(Map<String, dynamic> json) =>
      ApplicationVersionCheckerModel(
        downloadLink: json['app_download_link'],
        latestVersion: json['latest_version'],
        isCriticalUpdateRequired: json['is_critical_update_required'],
      );
}
