import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/shimmer_widgets/post_shimmers.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/logic/share_post_details/share_post_details_cubit.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/repository/share_post_details_repository.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';

//Social post details screen for the shared post link
class SharedSocialPostDetailsByLink extends StatelessWidget {
  final String encryptedData;
  const SharedSocialPostDetailsByLink({
    super.key,
    required this.encryptedData,
  });

  static const routeName = 'shared_social_post';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SharePostDetailsCubit(context.read<SharePostDetailsRepository>())
            ..fetchDeeplinkSharedPostDetails(encryptedData),
      child: const _SharedPostDetailsScreen(),
    );
  }
}

//Social post details screen for the notification tap navigation
class GeneralSharedSocialPostDetails extends StatelessWidget {
  final SharedPostDataModel sharedPostDataModel;
  const GeneralSharedSocialPostDetails({
    super.key,
    required this.sharedPostDataModel,
  });

  static const routeName = 'shared_social_post_with_type';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SharePostDetailsCubit(context.read<SharePostDetailsRepository>())
            ..fetchNotificationTapSharedPostDetails(sharedPostDataModel),
      child: const _SharedPostDetailsScreen(),
    );
  }
}

class _SharedPostDetailsScreen extends StatefulWidget {
  const _SharedPostDetailsScreen();

  @override
  State<_SharedPostDetailsScreen> createState() =>
      _SharedPostDetailsScreenState();
}

class _SharedPostDetailsScreenState extends State<_SharedPostDetailsScreen> {
  final scrollController = ScrollController();
  ShowReactionCubit showReactionCubit = ShowReactionCubit();

  @override
  void initState() {
    super.initState();

    //Listening for the scrolling speed
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollController.position.addListener(() {
    //     //When scrolling ensure that, the reaction option is close
    //     showReactionCubit.closeReactionEmojiOption();
    //   });
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ThemeAppBar(backgroundColor: Colors.white),
      body: BlocBuilder<SharePostDetailsCubit, PostDetailsState>(
        builder: (context, postDetailsState) {
          final socialPostDetails = postDetailsState.socialPostDetails;
          return postDetailsState.dataLoading
              ? const PostDetailsShimmer()
              : postDetailsState.error != null
                  ? ErrorTextWidget(error: postDetailsState.error!)
                  : SingleChildScrollView(
                      controller: scrollController,
                      child: MultiBlocProvider(
                        key: ValueKey(socialPostDetails!.id),
                        providers: [
                          BlocProvider(
                            create: (context) => PostDetailsControllerCubit(
                              socialPostModel: socialPostDetails,
                            ),
                          ),
                          BlocProvider.value(value: showReactionCubit),
                          BlocProvider(
                            create: (context) =>
                                PostActionCubit(PostActionRepository()),
                          ),
                          BlocProvider(
                            create: (context) =>
                                ReportCubit(ReportRepository()),
                          ),
                          BlocProvider(
                            create: (context) => CommentViewControllerCubit(),
                          ),

                          //Hide post cubit
                          BlocProvider(
                            create: (context) => HidePostCubit(
                              HidePostRepository(),
                            ),
                          ),
                        ],
                        child: PostViewWidget(
                          key: ValueKey(socialPostDetails.id),
                          enableGroupHeaderView: true,
                          allowNavigation: true,
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
