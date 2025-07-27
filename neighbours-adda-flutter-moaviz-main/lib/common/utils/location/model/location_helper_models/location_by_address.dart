class LocationByAddress {
  final List<LocationByAddressModel> predictedLocationList;
  LocationByAddress({
    this.predictedLocationList = const [],
  });

  factory LocationByAddress.fromMap(Map<String, dynamic> map) {
    return LocationByAddress(
      predictedLocationList: List<LocationByAddressModel>.from(
          map['predictions']?.map((x) => LocationByAddressModel.fromMap(x)) ??
              const []),
    );
  }

  factory LocationByAddress.fromJson(dynamic source) =>
      LocationByAddress.fromMap(source);
}

class LocationByAddressModel {
  final String title;
  final String description;
  final String placeId;
  final String reference;

  LocationByAddressModel({
    required this.title,
    required this.description,
    required this.placeId,
    required this.reference,
  });

  factory LocationByAddressModel.fromMap(Map<String, dynamic> map) =>
      LocationByAddressModel(
        title: map['structured_formatting']['main_text'],
        description: map['description'],
        placeId: map['place_id'],
        reference: map['reference'],
      );
}
