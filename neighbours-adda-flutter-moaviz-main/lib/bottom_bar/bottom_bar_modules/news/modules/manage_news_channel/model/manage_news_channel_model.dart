import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';

import '../../../../../../utility/constant/errors.dart';

class ManageNewsChannelModel {
  final String? id;
  final String name;
  final String description;
  final String? coverImageUrl;
  final String reporterName;
  final bool enableChat;

  //Location and radius
  final int preferenceRadius;
  final LocationAddressWithLatLng location;

  //language
  final LanguageEnum language;

  final bool enableGlobalNewsType;

  ManageNewsChannelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.reporterName,
    required this.enableChat,
    required this.preferenceRadius,
    required this.location,
    required this.language,
    this.enableGlobalNewsType = false,
  });

  //ToMap
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'image': coverImageUrl?.split('/').last,
      'contributor_name': reporterName,
      'enable_chat': enableChat,
      'post_preference_radius': preferenceRadius,
      'post_location': location.toJson(),
      'language': language.locale.languageCode,
      'allow_to_change_news_type': enableGlobalNewsType,
    };
  }

  //FromMap

  factory ManageNewsChannelModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildFromMap(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildFromMap(map);
    }
  }

  static ManageNewsChannelModel _buildFromMap(Map<String, dynamic> map) {
    return ManageNewsChannelModel(
      id: map['id'],
      name: map['name'],
      language: LanguageEnum.fromLanguageCode(map['language']),
      coverImageUrl: map['cover_image'],
      enableChat: map['enable_chat'],
      description: map['description'],
      reporterName: map['contributor_name'] ?? map['news_contributor'],
      preferenceRadius: map['post_preference_radius'] ?? 0,
      location: LocationAddressWithLatLng.fromMap(
        map['post_location'] ?? map['location'],
      ),
      enableGlobalNewsType: map['allow_to_change_news_type'],
    );
  }

  //Copy with
  ManageNewsChannelModel copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImageUrl,
    String? reporterName,
    bool? enableChat,
    int? preferenceRadius,
    LanguageEnum? language,
    bool? enableGlobalNewsType,
    LocationAddressWithLatLng? location,
  }) {
    return ManageNewsChannelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      reporterName: reporterName ?? this.reporterName,
      enableChat: enableChat ?? this.enableChat,
      preferenceRadius: preferenceRadius ?? this.preferenceRadius,
      location: location ?? this.location,
      language: language ?? this.language,
      enableGlobalNewsType: enableGlobalNewsType ?? this.enableGlobalNewsType,
    );
  }
}
