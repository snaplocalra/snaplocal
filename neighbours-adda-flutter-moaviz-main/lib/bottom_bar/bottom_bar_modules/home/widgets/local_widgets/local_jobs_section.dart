import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_jobs/local_jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_jobs/local_jobs_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/screen/jobs_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/screens/jobs_screen.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class LocalJobsSection extends StatefulWidget {
  const LocalJobsSection({super.key});

  @override
  State<LocalJobsSection> createState() => _LocalJobsSectionState();
}

class _LocalJobsSectionState extends State<LocalJobsSection> {
  late final LocalJobsCubit _localJobsCubit;

  @override
  void initState() {
    super.initState();
    _localJobsCubit = LocalJobsCubit(
      context.read<HomeDataRepository>(),
    );
    // Fetch local jobs when widget initializes
    _localJobsCubit.fetchLocalJobs();
  }

  @override
  void dispose() {
    _localJobsCubit.close();
    super.dispose();
  }

  Widget _buildShimmerItem() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ShimmerWidget(
              width: 48,
              height: 48,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerWidget(
                    width: 160,
                    height: 16,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShimmerWidget(
                    width: 120,
                    height: 14,
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _localJobsCubit,
      child: BlocBuilder<LocalJobsCubit, LocalJobsState>(
        builder: (context, state) {
          // Return empty widget if loading, has error, or no jobs
          if (state.dataLoading || state.error != null || state.jobs.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Local Jobs Near You',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1F71),
                      ),
                    ),
                    SeeAllButton(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          JobsScreen.routeName,
                          extra: JobsListType.byNeighbours,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.jobs.length,
                  itemBuilder: (context, index) {
                    final job = state.jobs[index];
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          JobDetailsScreen.routeName,
                          queryParameters: {
                            'id': job.id,
                            'job_title': job.jobDesignation,
                          },
                          extra: null,
                        );
                      },
                      child: Container(
                        width: 280,
                        margin: EdgeInsets.only(
                          right: index != state.jobs.length - 1 ? 16 : 0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      job.media.isNotEmpty
                                          ? job.media.first.mediaPath
                                          : 'assets/local_images/jobs.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      job.jobDesignation,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      job.companyName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
