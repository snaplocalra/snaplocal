import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/widgets/page_list_tile_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class PageSeeAllScreenDataWidget extends StatelessWidget {
  const PageSeeAllScreenDataWidget({
    super.key,
    required this.pageList,
    required this.header,
    required this.isLastPage,
    required this.onLoadMore,
  });

  final String header;
  final bool isLastPage;
  final List<PageModel> pageList;
  final void Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              header,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ApplicationColours.themeBlueColor,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pageList.length + 1,
            itemBuilder: (BuildContext context, index) {
              if (index < pageList.length) {
                final pageDetails = pageList[index];
                return PageListTileWidget(
                  key: ValueKey(pageDetails.pageId),
                  pageName: pageDetails.pageName,
                  isVerified: pageDetails.isVerified,
                  pageDescription: pageDetails.pageDescription,
                  pageId: pageDetails.pageId,
                  pageImageUrl: pageDetails.pageImage,
                  isFollowing: pageDetails.isFollowing,
                  isPageAdmin: pageDetails.isPageAdmin,
                  isBlockByUser: pageDetails.blockedByUser,
                  isBlockByAdmin: pageDetails.blockedByAdmin,
                  unSeenPostCount: pageDetails.unseenPostCount,
                  onPageFollowUnfollow: (isFollowing) {
                    pageDetails.isFollowing = isFollowing;
                    context.read<PageListCubit>().refreshState();
                  },
                );
              } else {
                if (isLastPage) {
                  return const SizedBox.shrink();
                } else {
                  return TextButton(
                    onPressed: onLoadMore,
                    child: Text(
                      "Load More",
                      style: TextStyle(
                        color: ApplicationColours.themePinkColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
