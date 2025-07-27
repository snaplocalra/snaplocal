import 'package:snap_local/common/utils/location/model/location_with_radius.dart';

class FavoriteLocationModel {
  final List<FavLocationInfoModel> locationList;

  FavoriteLocationModel({required this.locationList});

  factory FavoriteLocationModel.fromMap(Map<String, dynamic> map) {
    return FavoriteLocationModel(
      locationList: List<FavLocationInfoModel>.from(
        (map['data']).map(
          (x) => FavLocationInfoModel.fromMap(x),
        ),
      ),
    );
  }

  //Remove all selection
  void removeAllSelection() {
    for (var element in locationList) {
      element.isSelected = false;
    }
  }
}

class FavLocationInfoModel {
  final String id;
  final LocationWithPreferenceRadius locationWithPreferenceRadius;
  bool isSelected;

  FavLocationInfoModel({
    required this.id,
    required this.locationWithPreferenceRadius,
    this.isSelected = false,
  });

  factory FavLocationInfoModel.fromMap(Map<String, dynamic> map) {
    return FavLocationInfoModel(
      id: map['id'] as String,
      locationWithPreferenceRadius: LocationWithPreferenceRadius.fromMap(map),
      isSelected: map['is_selected'] as bool,
    );
  }

  FavLocationInfoModel copyWith({
    String? id,
    LocationWithPreferenceRadius? locationWithPreferenceRadius,
    bool? isSelected,
  }) {
    return FavLocationInfoModel(
      id: id ?? this.id,
      locationWithPreferenceRadius:
          locationWithPreferenceRadius ?? this.locationWithPreferenceRadius,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
