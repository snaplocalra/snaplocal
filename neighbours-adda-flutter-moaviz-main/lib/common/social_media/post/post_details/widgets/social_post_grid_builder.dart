import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/screens/post_details_view_screen.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/helper/manage_bottom_bar_visibility_on_scroll.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SocialPostGridBuilder extends StatefulWidget {
  const SocialPostGridBuilder({
    super.key,
    this.socialPostsModel,
    this.hideEmptyPlaceHolder = false,
    this.socialPostList,
    this.physics,
    this.onPaginationDataFetch,
    this.visibilityDetectorKeyValue,
    this.padding,
    this.scrollController,
    this.allowNavigation = true,
    this.enableGroupHeaderView = true,
    this.closeReactionOnScroll = false,
    this.showBottomDivider = true,
    this.allowAction = true,
    this.onRemoveItemFromList,
    this.onRemoveByUnsaved,
    this.enableVisibilityPaginationDataCallBack = false,
    this.refreshParentData,
    this.hideBottomBarOnScroll = true,
    this.enableNewsPostAction = true,
  });

  final SocialPostsList? socialPostsModel;
  final bool hideEmptyPlaceHolder;
  final List<SocialPostModel>? socialPostList;
  final void Function()? onPaginationDataFetch;
  final void Function(int index)? onRemoveItemFromList;
  final void Function(int index)? onRemoveByUnsaved;
  final String? visibilityDetectorKeyValue;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;

  ///If true then onPaginationDataFetch will call if the bottom widget visible
  final bool enableVisibilityPaginationDataCallBack;
  final EdgeInsetsGeometry? padding;

  //Actions
  final bool allowNavigation;
  final bool enableGroupHeaderView;
  final bool closeReactionOnScroll;
  final bool showBottomDivider;
  final bool allowAction;

  final void Function()? refreshParentData;

  //Bottom bar visibility on scroll
  final bool hideBottomBarOnScroll;

  //News post action
  final bool enableNewsPostAction;

  @override
  State<SocialPostGridBuilder> createState() => _SocialPostListBuilderState();
}

class _SocialPostListBuilderState extends State<SocialPostGridBuilder> {
  bool get paginationEnabled => widget.socialPostsModel != null;

  List<SocialPostModel> logs = [];

  bool _validateWidget() {
    if (widget.socialPostList == null && widget.socialPostsModel == null) {
      throw ("No social media data model found");
    } else if (paginationEnabled &&
        (widget.enableVisibilityPaginationDataCallBack &&
            widget.visibilityDetectorKeyValue == null)) {
      throw ("Visibility Detector KeyValue not found");
    } else if (widget.enableVisibilityPaginationDataCallBack &&
        widget.onPaginationDataFetch == null) {
      throw ("When enableVisibilityPaginationDataCallBack is true then onPaginationDataFetch() showStarMark");
    } else {
      return true;
    }
  }

  void assignDataModel() {
    if (_validateWidget()) {
      if (widget.socialPostList != null) {
        logs = widget.socialPostList!;
      } else if (widget.socialPostsModel != null) {
        logs = widget.socialPostsModel!.socialPostList;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    assignDataModel();

    if (widget.hideBottomBarOnScroll) {
      //Manage the bottom bar visibility on scroll
      ManageBottomBarVisibilityOnScroll(context).init(widget.scrollController);
    }
  }

  @override
  void didUpdateWidget(covariant SocialPostGridBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      assignDataModel();
    }
  }

  void navigateToPostDetails(
    BuildContext localContext,
    SocialPostModel postDetails,
  ) {
    GoRouter.of(context).pushNamed(
      PostDetailsViewScreen.routeName,
      extra: <String, dynamic>{
        "reportCubit": localContext.read<ReportCubit>(),
        "postActionCubit": localContext.read<PostActionCubit>(),
        "postDetailsControllerCubit":
            localContext.read<PostDetailsControllerCubit>(),
        "showReactionCubit": localContext.read<ShowReactionCubit>(),
        "allowNavigation": widget.allowNavigation.toString(),
        "commentViewControllerCubit":
            localContext.read<CommentViewControllerCubit>(),
        "hidePostCubit": localContext.read<HidePostCubit>(),
      },
    ).then((value) {
      //This is a temporary solution to close the post details screen and
      //run the fetch data function in the parent screen
      if (value != null && value == true) {
        widget.refreshParentData?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return (logs.isEmpty)
        ? widget.hideEmptyPlaceHolder
            ? const SizedBox.shrink()
            : const Center(
                child: EmptyDataPlaceHolder(
                  emptyDataType: EmptyDataType.post,
                ),
              )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            controller: widget.scrollController,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            physics: widget.physics ?? const NeverScrollableScrollPhysics(),
            itemCount: paginationEnabled ? logs.length + 1 : logs.length,
            itemBuilder: (context, index) {
              if (!paginationEnabled || index < logs.length) {
                //Post details
                final postDetails = logs[index];

                //Post Action cubit
                final postActionCubit = PostActionCubit(PostActionRepository());

                final postDetailsControllerCubit =
                    PostDetailsControllerCubit(socialPostModel: postDetails);

                //Report cubit
                final reportCubit = ReportCubit(ReportRepository());

                //comment view controller cubit
                final commentViewControllerCubit = CommentViewControllerCubit();

                //Hide post cubit
                final HidePostCubit hidePostCubit =
                    HidePostCubit(HidePostRepository());

                return MultiBlocProvider(
                  key: ValueKey(postDetails.id),
                  providers: [
                    BlocProvider.value(value: postDetailsControllerCubit),
                    BlocProvider.value(value: postActionCubit),
                    BlocProvider.value(value: reportCubit),
                    BlocProvider.value(value: commentViewControllerCubit),
                    BlocProvider.value(value: hidePostCubit),
                  ],
                  child: Builder(builder: (context) {
                    return BlocListener<PostDetailsControllerCubit,
                        PostDetailsControllerState>(
                      listener: (context, postDetailsControllerState) {
                        if (postDetailsControllerState.removeItemFromList) {
                          widget.onRemoveItemFromList?.call(index);
                        } else if (postDetailsControllerState.removeByUnsaved) {
                          widget.onRemoveByUnsaved?.call(index);
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          navigateToPostDetails(context, postDetails);
                        },
                        child: AbsorbPointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: NetworkMediaWidget(
                              media: postDetails.media.first,
                              fit: BoxFit.cover,
                              fromGrid: true,
                              isFirst: index==0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              } else {
                if (widget.socialPostsModel!.paginationModel.isLastPage) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: SizedBox.shrink(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: widget.enableVisibilityPaginationDataCallBack
                        ? VisibilityDetector(
                            key: Key(widget.visibilityDetectorKeyValue!),
                            onVisibilityChanged: (visibilityInfo) {
                              var visiblePercentage =
                                  visibilityInfo.visibleFraction * 100;
                              if (visiblePercentage >= 60) {
                                if (widget.onPaginationDataFetch != null) {
                                  widget.onPaginationDataFetch!.call();
                                }
                              }
                            },
                            child: const ThemeSpinner(size: 40),
                          )
                        : const ThemeSpinner(size: 40),
                  );
                }
              }
            },
          );
  }
}
