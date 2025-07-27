class AddressComponentModel {
  final List<AddressComponent> addressComponents;

  AddressComponentModel({required this.addressComponents});

  factory AddressComponentModel.fromJson(List<dynamic> json) {
    return AddressComponentModel(
      addressComponents: json.map((x) => AddressComponent.fromJson(x)).toList(),
    );
  }
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );
}
