import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/screen/create_or_update_page_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/logic/page_details/page_details_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/logic/page_connection_action/page_connection_action_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/repository/page_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/widgets/page_invite_button.dart';
import 'package:snap_local/common/social_media/profile/connections/models/connection_status.dart';
import 'package:snap_local/common/social_media/profile/connections/widgets/connection_action_button.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PageConnectionActionWidget extends StatefulWidget {
  const PageConnectionActionWidget({
    super.key,
    this.isExitpageLoading = false,
    this.isSendRequestLoading = false,
    required this.pageId,
    required this.isPageOwner,
    required this.connectionStatus,
    required this.pageProfileDetailsModel,
    required this.requestSuccessCallback,
  });

  final bool isExitpageLoading;
  final bool isSendRequestLoading;
  final String pageId;
  final bool isPageOwner;
  final ConnectionStatus connectionStatus;
  final PageProfileDetailsModel pageProfileDetailsModel;
  final void Function() requestSuccessCallback;

  @override
  State<PageConnectionActionWidget> createState() =>
      _PageConnectionActionWidgetState();
}

class _PageConnectionActionWidgetState
    extends State<PageConnectionActionWidget> {
  late PageConnectionActionCubit pageConnectionActionCubit;

  @override
  void initState() {
    super.initState();
    pageConnectionActionCubit = PageConnectionActionCubit(
        pageConnectionRepository: context.read<PageConnectionRepository>());
  }

  @override
  void didUpdateWidget(covariant PageConnectionActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    pageConnectionActionCubit.stopLoading();
  }

  final double buttonHeight = 30;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: pageConnectionActionCubit,
      child: BlocConsumer<PageConnectionActionCubit, PageConnectionActionState>(
        listener: (context, pageConnectionActionState) {
          if (mounted && pageConnectionActionState.isRequestSuccess) {
            widget.requestSuccessCallback.call();
          }
        },
        builder: (context, pageConnectionActionState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Normal user buttons
              Visibility(
                visible: !(widget.isPageOwner ||
                    widget.pageProfileDetailsModel.blockedByAdmin ||
                    widget.pageProfileDetailsModel.blockedByUser),
                child: widget.connectionStatus == ConnectionStatus.notConnected
                    ?
                    //page Follow Button
                    ConnectionActionButton(
                        height: buttonHeight,
                        backgroundColor: ApplicationColours.themeBlueColor,
                        buttonName: LocaleKeys.follow,
                        showLoadingSpinner: pageConnectionActionState
                            .isSendAndRemovePageFollowRequestLoading,
                        onPressed: () {
                          context
                              .read<PageConnectionActionCubit>()
                              .sendAndCancelPageFollowRequest(widget.pageId);
                        },
                      )
                    : widget.connectionStatus == ConnectionStatus.connected
                        ? Expanded(
                            child: Row(
                              children: [
                                //page Invite Button
                                PageInviteButton(
                                  buttonHeight: buttonHeight,
                                  pageId: widget.pageId,
                                ),
                                //page Exit Button
                                ConnectionActionButton(
                                  height: buttonHeight,
                                  buttonName: LocaleKeys.unFollow,
                                  backgroundColor:
                                      const Color.fromRGBO(233, 236, 239, 1),
                                  foregroundColor: Colors.black,
                                  showLoadingSpinner: pageConnectionActionState
                                      .isExitPageRequestLoading,
                                  onPressed: () {
                                    context
                                        .read<PageConnectionActionCubit>()
                                        .exitPageFollowRequest(widget.pageId);
                                  },
                                ),
                              ],
                            ),
                          )
                        :
                        //There is no connection pending in page, so the below return widget is blank
                        const SizedBox.shrink(),
              ),
              //page owner buttons
              Visibility(
                visible: widget.isPageOwner,
                child: Expanded(
                  child: Row(
                    children: [
                      //page Invite Button
                      PageInviteButton(
                        buttonHeight: buttonHeight,
                        pageId: widget.pageId,
                      ),
                      //page Edit Button
                      ConnectionActionButton(
                        prefixSvgSize: 15,
                        height: buttonHeight,
                        prefixSvg: SVGAssetsImages.edit,
                        buttonName: LocaleKeys.editPage,
                        prefixSvgColour: ApplicationColours.themeBlueColor,
                        foregroundColor: Colors.black,
                        backgroundColor: const Color.fromRGBO(233, 236, 239, 1),
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(
                                CreateOrUpdatePageDetailsScreen.routeName,
                                extra: widget.pageProfileDetailsModel,
                              )
                              .whenComplete(
                                () => context
                                    .read<PageDetailsCubit>()
                                    .fetchPageDetails(pageId: widget.pageId),
                              );
                        },
                      ),
                      //      PageAnalyticsButton(
                      //   buttonHeight: buttonHeight,
                      //   pageId: widget.pageId,
                      //   foregroundColor: Colors.black,
                      //   backgroundColor: const Color.fromRGBO(233, 236, 239, 1),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
