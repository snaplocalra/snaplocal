// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/private_group_join_requests/private_group_join_requests_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/widgets/private_group_join_request_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class PrivateGroupJoinRequestScreen extends StatefulWidget {
  final String groupId;
  final PrivateGroupJoinRequestsCubit? privateGroupJoinRequestsCubit;

  static const routeName = 'private_group_join_requests';

  const PrivateGroupJoinRequestScreen({
    super.key,
    required this.groupId,
    this.privateGroupJoinRequestsCubit,
  });

  @override
  State<PrivateGroupJoinRequestScreen> createState() =>
      _PrivateGroupJoinRequestScreenState();
}

class _PrivateGroupJoinRequestScreenState
    extends State<PrivateGroupJoinRequestScreen> {
  final pendingRequestScrollController = ScrollController();

  late PrivateGroupJoinRequestsCubit privateGroupJoinRequestsCubit;
  @override
  void initState() {
    super.initState();
    if (widget.privateGroupJoinRequestsCubit != null) {
      privateGroupJoinRequestsCubit = widget.privateGroupJoinRequestsCubit!;
    } else {
      privateGroupJoinRequestsCubit = PrivateGroupJoinRequestsCubit(
          context.read<GroupConnectionRepository>());
    }

    //Fetch data
    privateGroupJoinRequestsCubit.fetchPrivateGroupJoinRequets(
        groupId: widget.groupId);
  }

  @override
  void dispose() {
    super.dispose();
    pendingRequestScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: privateGroupJoinRequestsCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ThemeAppBar(
          backgroundColor: Colors.white,
          title: Text(
            tr(LocaleKeys.joinRequests),
            style: TextStyle(color: ApplicationColours.themeBlueColor),
          ),
        ),
        body: BlocBuilder<PrivateGroupJoinRequestsCubit,
            PrivateGroupJoinRequestsState>(
          builder: (context, privateGroupJoinRequestsState) {
            if (privateGroupJoinRequestsState.error != null) {
              return ErrorTextWidget(
                  error: privateGroupJoinRequestsState.error!);
            } else if (privateGroupJoinRequestsState.dataLoading) {
              return const CircleCardShimmerListBuilder(
                padding: EdgeInsets.symmetric(vertical: 15),
              );
            } else {
              final pendingRequests =
                  privateGroupJoinRequestsState.groupConnectionListModel;
              final logs = pendingRequests?.data ?? [];
              if (logs.isEmpty) {
                return const ErrorTextWidget(error: "No requests found");
              } else {
                return RefreshIndicator.adaptive(
                  onRefresh: () => context
                      .read<PrivateGroupJoinRequestsCubit>()
                      .fetchPrivateGroupJoinRequets(groupId: widget.groupId),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    controller: pendingRequestScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: logs.length + 1,
                    itemBuilder: (BuildContext context, index) {
                      if (index < logs.length) {
                        final requestDetails = logs[index];
                        return PrivateGroupJoinRequestWidget(
                          requestedUserId: requestDetails.requestedUserId,
                          connectionId: requestDetails.id,
                          imageUrl: requestDetails.requestedUserImage,
                          name: requestDetails.requestedUserName,
                          address: requestDetails.address,
                          groupId: widget.groupId,
                        );
                      } else {
                        if (pendingRequests!.paginationModel.isLastPage) {
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
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
