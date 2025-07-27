part of 'home_banners_cubit.dart';

class HomeBannersState extends Equatable {
  final bool isTopBannersDataLoading;
  final bool isBottomBannersDataLoading;
  final HomeBannersList homeBanners;
  const HomeBannersState({
    this.isTopBannersDataLoading = false,
    this.isBottomBannersDataLoading = false,
    required this.homeBanners,
  });

  @override
  List<Object?> get props =>
      [homeBanners, isTopBannersDataLoading, isBottomBannersDataLoading];

  HomeBannersState copyWith({
    bool? isTopBannersDataLoading,
    bool? isBottomBannersDataLoading,
    HomeBannersList? homeBanners,
  }) {
    return HomeBannersState(
      isTopBannersDataLoading:
          isTopBannersDataLoading ?? this.isTopBannersDataLoading,
      isBottomBannersDataLoading:
          isBottomBannersDataLoading ?? this.isBottomBannersDataLoading,
      homeBanners: homeBanners ?? this.homeBanners,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isTopBannersDataLoading': isTopBannersDataLoading,
      'isBottomBannersDataLoading': isBottomBannersDataLoading,
      'homeBanners': homeBanners.toMap(),
    };
  }

  factory HomeBannersState.fromMap(Map<String, dynamic> map) {
    return HomeBannersState(
      isTopBannersDataLoading:
          (map['isTopBannersDataLoading'] ?? false) as bool,
      isBottomBannersDataLoading:
          (map['isBottomBannersDataLoading'] ?? false) as bool,
      homeBanners:
          HomeBannersList.fromMap(map['homeBanners'] as Map<String, dynamic>),
    );
  }
}
