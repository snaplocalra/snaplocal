import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/connections/logic/profile_connection/profile_connection_cubit.dart';
import 'package:snap_local/profile/connections/models/profile_connection_list_model.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/profile/connections/widgets/profile_connection_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';

class ProfileConnectionListBuilder extends StatelessWidget {
  const ProfileConnectionListBuilder({
    super.key,
    required this.connectionType,
    required this.connectionScrollController,
  });

  final ProfileConnectionType connectionType;
  final ScrollController connectionScrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileConnectionsCubit, ProfileConnectionsState>(
      builder: (context, profileConnectionsState) {
        final showLoadingByType =
            connectionType == ProfileConnectionType.myConnections
                ? profileConnectionsState.isMyConenctionDataLoading
                : profileConnectionsState.isRequestedConnectionDataLoading;
        if (profileConnectionsState.error != null) {
          return ErrorTextWidget(error: profileConnectionsState.error!);
        } else if (showLoadingByType) {
          return const CircleCardShimmerListBuilder(
            padding: EdgeInsets.symmetric(vertical: 15),
          );
        } else {
          late ProfileConnectionListModel connectionsList;
          if (connectionType == ProfileConnectionType.myConnections) {
            connectionsList =
                profileConnectionsState.connectionListModel.myConnections;
          } else {
            connectionsList =
                profileConnectionsState.connectionListModel.requestedConnection;
          }
          final logs = connectionsList.data;
          if (logs.isEmpty) {
            final message =
                connectionType == ProfileConnectionType.myConnections
                    ? "No connection found"
                    : "No connection request found";
            return ErrorTextWidget(error: message);
          } else {
            return RefreshIndicator.adaptive(
              onRefresh: () => context
                  .read<ProfileConnectionsCubit>()
                  .fetchConnections(profileConnectionType: connectionType),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                controller: connectionScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: logs.length + 1,
                itemBuilder: (BuildContext context, index) {
                  if (index < logs.length) {
                    final connectionDetails = logs[index];
                    return ProfileConnectionWidget(
                      key: Key(connectionDetails.id),
                      requestedUserId: connectionDetails.requestedUserId,
                      connectionId: connectionDetails.id,
                      imageUrl: connectionDetails.requestedUserImage,
                      name: connectionDetails.requestedUserName,
                      address: connectionDetails.address,
                      isVerified: connectionDetails.isVerified,
                      connectionType: connectionType,
                    );
                  } else {
                    if (connectionsList.paginationModel.isLastPage) {
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
    );
  }
}
