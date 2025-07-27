class SupportReportModel {
  final String email;
  final String description;

  SupportReportModel({
    required this.email,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'description': description,
    };
  }
}
