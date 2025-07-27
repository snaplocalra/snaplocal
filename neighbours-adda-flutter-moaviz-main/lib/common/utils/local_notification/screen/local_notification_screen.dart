import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';
import 'package:snap_local/common/utils/empty_data_handler/widgets/empty_data_place_holder.dart';
import 'package:snap_local/common/utils/local_notification/logic/local_notification_view/local_notification_view_cubit.dart';
import 'package:snap_local/common/utils/local_notification/widgets/local_notification_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class LocalNotificationViewScreen extends StatefulWidget {
  const LocalNotificationViewScreen({super.key});

  static const routeName = 'notifications';

  @override
  State<LocalNotificationViewScreen> createState() =>
      _LocalNotificationViewScreenState();
}

class _LocalNotificationViewScreenState
    extends State<LocalNotificationViewScreen> {
  final notificationScrollController = ScrollController();

  void listenToScroll() {
    notificationScrollController.position.addListener(() {
      if (notificationScrollController.position.maxScrollExtent ==
          notificationScrollController.offset) {
        context
            .read<LocalNotificationViewCubit>()
            .fetchNotifications(loadMoreData: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<LocalNotificationViewCubit>().fetchNotifications();

    //Listening for the scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenToScroll();
    });
  }

  @override
  void dispose() {
    super.dispose();
    notificationScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ThemeAppBar(
        backgroundColor: Colors.white,
        title: Text(
          tr(LocaleKeys.notifications),
          style: TextStyle(color: ApplicationColours.themeBlueColor),
        ),
      ),
      body: SingleChildScrollView(
        controller: notificationScrollController,
        child:
            BlocBuilder<LocalNotificationViewCubit, LocalNotificationViewState>(
          builder: (context, state) {
            if (state.error != null) {
              return ErrorTextWidget(error: state.error!);
            } else if (state.dataLoading) {
              return const CircleCardShimmerListBuilder(
                padding: EdgeInsets.symmetric(vertical: 10),
              );
            } else {
              final logs = state.localNotificationList.data;
              if (logs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: mqSize.height * 0.15),
                    child: const EmptyDataPlaceHolder(
                      emptyDataType: EmptyDataType.notification,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length + 1,
                  itemBuilder: (context, index) {
                    if (index < logs.length) {
                      final localNotification = logs[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: LocalNotificationWidget(
                          localNotificationModel: localNotification,
                        ),
                      );
                    } else {
                      if (state
                          .localNotificationList.paginationModel.isLastPage) {
                        return const SizedBox.shrink();
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: ThemeSpinner(size: 30),
                        );
                      }
                    }
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
