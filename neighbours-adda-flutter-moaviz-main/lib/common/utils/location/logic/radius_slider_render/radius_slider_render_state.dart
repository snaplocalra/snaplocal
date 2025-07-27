part of 'radius_slider_render_cubit.dart';

class RadiusSliderRenderState extends Equatable {
  final bool isLoading;
  final bool requestSucceed;
  final FeedRadiusModel feedRadiusModel;

  const RadiusSliderRenderState({
    this.isLoading = false,
    this.requestSucceed = false,
    required this.feedRadiusModel,
  });

  @override
  List<Object?> get props => [isLoading, requestSucceed, feedRadiusModel];

  RadiusSliderRenderState copyWith({
    bool? isLoading,
    bool? requestSucceed,
    FeedRadiusModel? feedRadiusModel,
  }) {
    return RadiusSliderRenderState(
      isLoading: isLoading ?? false,
      requestSucceed: requestSucceed ?? false,
      feedRadiusModel: feedRadiusModel ?? this.feedRadiusModel,
    );
  }
}
