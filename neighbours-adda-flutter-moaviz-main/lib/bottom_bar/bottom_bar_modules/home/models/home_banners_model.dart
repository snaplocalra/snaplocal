import 'package:snap_local/common/utils/models/route_navigation_model.dart';

import '../../../../utility/constant/errors.dart';
class HomeBannersList {
  List<HomeBannerModel> topBannersList;
  List<HomeBannerModel> bottomBannersList;

  HomeBannersList({
    required this.topBannersList,
    required this.bottomBannersList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'top_banners': topBannersList.map((x) => x.toMap()).toList(),
      'bottom_banners': bottomBannersList.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeBannersList.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildBanners(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildBanners(map);
    }
  }

  static HomeBannersList _buildBanners(Map<String, dynamic> map) {
    return HomeBannersList(
      topBannersList: List<HomeBannerModel>.from(
        (map['top_banners']).map<HomeBannerModel>(
              (x) => HomeBannerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      bottomBannersList: List<HomeBannerModel>.from(
        (map['bottom_banners']).map<HomeBannerModel>(
              (x) => HomeBannerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class HomeBannerModel {
  final String id;
  final String image;
  final String? hyperLink;
  final RouteNavigationModel? routeNavigationModel;

  HomeBannerModel({
    required this.id,
    required this.hyperLink,
    required this.image,
    required this.routeNavigationModel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'hyper_link': hyperLink,
      'navigation_details': routeNavigationModel?.toMap(),
    };
  }

  factory HomeBannerModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildBanner(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildBanner(map);
    }
  }

  static HomeBannerModel _buildBanner(Map<String, dynamic> map) {
    return HomeBannerModel(
      id: (map['id'] ?? '') as String,
      image: (map['image'] ?? '') as String,
      hyperLink: map['hyper_link'] != null ? map['hyper_link'] as String : null,
      routeNavigationModel: map['navigation_details'] != null
          ? RouteNavigationModel.fromMap(map['navigation_details'])
          : null,
    );
  }
}
