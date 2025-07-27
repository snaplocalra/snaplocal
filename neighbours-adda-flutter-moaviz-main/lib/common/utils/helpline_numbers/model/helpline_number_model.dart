class HelplineNumberModel {
  final String contactNumber;
  final String contactName;
  final String imageUrl;

  HelplineNumberModel({
    required this.contactNumber,
    required this.contactName,
    required this.imageUrl,
  });

  factory HelplineNumberModel.fromJson(Map<String, dynamic> json) {
    return HelplineNumberModel(
      contactNumber: json['contact_number'],
      contactName: json['contact_name'],
      imageUrl: json['image'],
    );
  }
}
