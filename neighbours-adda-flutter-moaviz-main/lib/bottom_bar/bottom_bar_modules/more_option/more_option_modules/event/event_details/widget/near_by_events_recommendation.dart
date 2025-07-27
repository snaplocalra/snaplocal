import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/widgets/event_short_details_list_widget.dart';
import 'package:snap_local/common/social_media/post/master_post/model/categories_view/event_post_model.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';

class NearByEventsRecommendation extends StatefulWidget {
  const NearByEventsRecommendation({
    super.key,
    required this.nearbyList,
  });

  final List<EventPostModel> nearbyList;

  @override
  State<NearByEventsRecommendation> createState() =>
      _NearByEventsRecommendationState();
}

class _NearByEventsRecommendationState extends State<NearByEventsRecommendation>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double height = 140;
    double width = 350;
    return Visibility(
      visible: widget.nearbyList.isNotEmpty,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              tr(LocaleKeys.nearByEvents),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: height,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.nearbyList.length,
              itemBuilder: (context, index) {
                final eventPostDetails = widget.nearbyList[index];

                //Post Action cubit
                final postActionCubit = PostActionCubit(PostActionRepository());

                //Post details controller
                final postDetailsControllerCubit = PostDetailsControllerCubit(
                    socialPostModel: eventPostDetails);
                return FittedBox(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    child: MultiBlocProvider(
                      key: ValueKey(eventPostDetails.id),
                      providers: [
                        BlocProvider.value(value: postActionCubit),
                        BlocProvider.value(value: postDetailsControllerCubit),
                      ],
                      child: Builder(builder: (context) {
                        return SizedBox(
                          width: width,
                          child: const EventShortDetailsListWidget(),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
