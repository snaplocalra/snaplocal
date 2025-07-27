import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_pages/home_local_pages_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_page_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_see_all_screen.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

import '../../../groups/logic/search_filter_controller/search_filter_controller_cubit.dart';
import '../../../groups/models/search_filter_type.dart';
import '../../../more_option/more_option_modules/page/logic/page_home_data/page_home_data_cubit.dart';
import '../../../more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';

class LocalPagesSection extends StatefulWidget {
  const LocalPagesSection({super.key});

  @override
  State<LocalPagesSection> createState() => _LocalPagesSectionState();
}

class _LocalPagesSectionState extends State<LocalPagesSection> {
  //Search filter type
  SearchFilterTypeEnum searchFilterTypeEnum = SearchFilterTypeEnum.yourPages;
  late SearchFilterControllerCubit searchFilterControllerCubit =
  SearchFilterControllerCubit(PageSearchFilter());
  @override
  void initState() {
    super.initState();
    // Fetch local pages when widget initializes
    context.read<HomeLocalPagesCubit>().fetchHomeLocalPages();
    //Fetch both type Pages data
    context.read<PageListCubit>().fetchPages();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Fetch the initial data
      context
          .read<PageHomeDataCubit>()
          .fetchGroupHomeData(searchFilterTypeEnum);

      //Listen to the search filter type and fetch the data
      searchFilterControllerCubit.stream.listen(
            (state) {
          if (state.selectedSearchFilterTypeCategory != null) {
            searchFilterTypeEnum = state.selectedSearchFilterTypeCategory!.type;
            if (mounted) {
              context
                  .read<PageHomeDataCubit>()
                  .fetchGroupHomeData(searchFilterTypeEnum);
            }
          }
        },
      );

      //Listen to the group home data, and if the data come empty for Your Groups, then select the Suggested group
      context.read<PageHomeDataCubit>().stream.listen((state) {
        if (state is PageHomeDataLoaded) {
          if (state.data.isEmpty &&
              searchFilterTypeEnum == SearchFilterTypeEnum.yourPages) {
            searchFilterControllerCubit
                .selectSearchFilterType(SearchFilterTypeEnum.suggested);
          }
        }
      });
    });
  }

  Widget _buildShimmerItem() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ShimmerWidget(
            width: 100,
            height: 120,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 70,
                  height: 12,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                ShimmerWidget(
                  width: 50,
                  height: 10,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeLocalPagesCubit, HomeLocalPagesState>(
      builder: (context, state) {
        // Return empty widget if loading, has error, or no pages
        if (state.dataLoading ||
            state.error != null ||
            state.localPages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Local Pages Near You',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SeeAllButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SeeAllAscreenPages(),
                          ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.localPages.length,
                itemBuilder: (context, index) {
                  final page = state.localPages[index];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        PageDetailsScreen.routeName,
                        queryParameters: {'id': page.pageId},
                        extra: index,
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(page.pageImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            right: 12,
                            bottom: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  page.pageName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${page.followersCount} Members',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
