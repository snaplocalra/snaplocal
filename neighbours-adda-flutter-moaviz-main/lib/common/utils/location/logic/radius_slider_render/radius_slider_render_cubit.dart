// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/location/model/feed_radius_model.dart';

part 'radius_slider_render_state.dart';

class RadiusSliderRenderCubit extends Cubit<RadiusSliderRenderState> {
  RadiusSliderRenderCubit()
      : super(
            const RadiusSliderRenderState(feedRadiusModel: FeedRadiusModel()));

  Future<void> emitRadius(FeedRadiusModel feedRadiusModel) async {
    emit(state.copyWith(feedRadiusModel: feedRadiusModel));
  }
}
