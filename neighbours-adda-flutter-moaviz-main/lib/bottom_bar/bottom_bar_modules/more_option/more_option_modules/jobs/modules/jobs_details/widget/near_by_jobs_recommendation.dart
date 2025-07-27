import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/widgets/job_short_details_widget.dart';

class NearByJobsRecommendation extends StatelessWidget {
  const NearByJobsRecommendation({
    super.key,
    required this.nearbyList,
  });

  final List<JobShortDetailsModel> nearbyList;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    double listHeight = mqSize.height * 0.22;

    return Visibility(
      visible: nearbyList.isNotEmpty,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                tr(LocaleKeys.similarJobs),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: listHeight,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: nearbyList.length,
                itemBuilder: (context, index) {
                  final jobsDetails = nearbyList[index];
                  return MultiBlocProvider(
                    key: ValueKey(jobsDetails.id),
                    providers: [
                      BlocProvider(
                        create: (context) => JobShortViewControllerCubit(
                          jobShortDetailsModel: jobsDetails,
                        ),
                      ),
                    ],
                    child: FittedBox(
                      child: JobShortDetailsWidget(
                        width: mqSize.width * 0.6,
                        cardColor: Colors.grey.shade50,
                        skillColor: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
