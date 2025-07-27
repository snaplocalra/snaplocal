// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/logic/page_connection_action/page_connection_action_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/repository/page_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/common/utils/widgets/unseen_post_count_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../../../utility/constant/assets_images.dart';

class PageListTileWidget extends StatefulWidget {
  const PageListTileWidget({
    super.key,
    required this.pageName,
    required this.pageDescription,
    required this.pageId,
    required this.pageImageUrl,
    this.dataRefreshCallback,
    required this.unSeenPostCount,
    required this.isFollowing,
    required this.isPageAdmin,
    this.onPageFollowUnfollow,
    required this.isBlockByUser,
    required this.isBlockByAdmin,
    required this.isVerified,
  });

  final String pageName;
  final String pageDescription;
  final String pageId;
  final String pageImageUrl;
  final int unSeenPostCount;

  //use on the search page screen
  final bool isFollowing;
  final bool isPageAdmin;
  final bool isVerified;
  final void Function(bool isFollowing)? onPageFollowUnfollow;
  final void Function()? dataRefreshCallback;
  final bool isBlockByUser;
  final bool isBlockByAdmin;
  @override
  State<PageListTileWidget> createState() => _PageListTileWidgetState();
}

class _PageListTileWidgetState extends State<PageListTileWidget> {
  late PageConnectionActionCubit pageConnectionActionCubit;

  bool showPageConnection = false;

  @override
  void initState() {
    super.initState();

    //Assign the condition to show page connection button
    showPageConnection =
        //The current user is not the page admin
        !widget.isPageAdmin &&

            //The current user is not blocked the page and the page admin not blocked the user
            (!widget.isBlockByUser && !widget.isBlockByAdmin) &&

            //if the follow unfollow callback is not null
            (widget.onPageFollowUnfollow != null);

    pageConnectionActionCubit = PageConnectionActionCubit(
        pageConnectionRepository: context.read<PageConnectionRepository>());
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          PageDetailsScreen.routeName,
          queryParameters: {'id': widget.pageId},
        ).whenComplete(() {
          if (widget.dataRefreshCallback != null) {
            widget.dataRefreshCallback!.call();
          }
        });
      },
      child: AbsorbPointer(
        absorbing: !showPageConnection,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageCircleAvatar(
                radius: mqSize.width * 0.06,
                imageurl: widget.pageImageUrl,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.pageName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if(widget.isVerified==true)...[
                                    const SizedBox(width: 2),
                                    SvgPicture.asset(
                                      SVGAssetsImages.greenTick,
                                      height: 12,
                                      width: 12,
                                    ),
                                  ],
                                ],
                              ),
                              Visibility(
                                visible: widget.pageDescription.isNotEmpty,
                                child: Text(
                                  widget.pageDescription,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        UnSeenCountWidget(
                          unSeenPostCount: widget.unSeenPostCount,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        )
                      ],
                    ),

                    //Page connection button
                    if (showPageConnection)
                      BlocProvider.value(
                        value: pageConnectionActionCubit,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            width: mqSize.width * 0.3,
                            child: Row(children: [
                              BlocConsumer<PageConnectionActionCubit,
                                  PageConnectionActionState>(
                                listener: (context, pageConnectionActionState) {
                                  if (pageConnectionActionState
                                      .isRequestSuccess) {
                                    context
                                        .read<PageConnectionActionCubit>()
                                        .stopLoading();
                                  }
                                },
                                builder: (context, pageConnectionActionState) {
                                  return ConnectionActionButton(
                                    height: 30,
                                    foregroundColor: widget.isFollowing
                                        ? Colors.black
                                        : Colors.white,
                                    backgroundColor: widget.isFollowing
                                        ? const Color.fromRGBO(233, 236, 239, 1)
                                        : ApplicationColours.themeBlueColor,
                                    buttonName: widget.isFollowing
                                        ? LocaleKeys.unFollow
                                        : LocaleKeys.follow,
                                    onPressed: () {
                                      widget.onPageFollowUnfollow!
                                          .call(!widget.isFollowing);
                                      context
                                          .read<PageConnectionActionCubit>()
                                          .sendAndCancelPageFollowRequest(
                                              widget.pageId);
                                    },
                                  );
                                },
                              ),
                            ]),
                          ),
                        ),
                      ),
                    const Visibility(
                      // visible: widget.pageDescription.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Divider(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
