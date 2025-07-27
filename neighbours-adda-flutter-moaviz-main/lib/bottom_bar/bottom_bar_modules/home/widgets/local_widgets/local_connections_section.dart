import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/screen/explore_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/connection_connect/connection_connect_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/connection_ignore/connection_ignore_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_connections/local_connections_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_connections/local_connections_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class ConnectionsSection extends StatefulWidget {
  const ConnectionsSection({super.key});

  @override
  State<ConnectionsSection> createState() => _ConnectionsSectionState();
}

class _ConnectionsSectionState extends State<ConnectionsSection> {
  @override
  void initState() {
    super.initState();
    // Load connections when widget initializes
    context.read<LocalConnectionsCubit>().loadConnections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalConnectionsCubit, LocalConnectionsState>(
      builder: (context, state) {
        if (state.dataLoading) {
          return _buildLoadingState();
        }

        if (state.error != null || state.connections.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Connections you may like',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E), // Dark blue color
                    ),
                  ),
                  SeeAllButton(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        ExploreScreen.routeName,
                        extra: true,
                      );
                      // Handle see all tap
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220, // Increased height for the container
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.connections.length,
                itemBuilder: (context, index) {
                  final connection = state.connections[index];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        NeighboursProfileAndPostsScreen.routeName,
                        queryParameters: {'id': connection.id},
                      );
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade50,
                            Colors.grey.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(connection.image),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            connection.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A237E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (connection.connectionStatus.connectionStatus == 'not_connected') ...[
                                BlocBuilder<ConnectionConnectCubit, ConnectionConnectState>(
                                  builder: (context, connectState) {
                                    final isConnecting = connectState is ConnectionConnectLoading && 
                                                       connectState.userId == connection.id;
                                    return ElevatedButton(
                                      onPressed: isConnecting
                                          ? null
                                          : () {
                                              context.read<ConnectionConnectCubit>().handleConnection(connection.id).then((_) {
                                                // Refresh connections after connecting
                                                context.read<LocalConnectionsCubit>().loadConnections();
                                              });
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pink,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: isConnecting
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Connect',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                BlocBuilder<ConnectionIgnoreCubit, ConnectionIgnoreState>(
                                  builder: (context, ignoreState) {
                                    final isIgnoring = ignoreState is ConnectionIgnoreLoading && 
                                                    ignoreState.userId == connection.id;
                                    return ElevatedButton(
                                      onPressed: isIgnoring
                                          ? null
                                          : () {
                                              context.read<ConnectionIgnoreCubit>().ignoreConnection(connection.id).then((_) {
                                                // Refresh connections after ignoring
                                                context.read<LocalConnectionsCubit>().loadConnections();
                                              });
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade200,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: isIgnoring
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Ignore',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                    );
                                  },
                                ),
                              ]
                              else if (connection.connectionStatus.connectionStatus == 'request_pending') ...[
                                if (connection.connectionStatus.isConnectionRequestSender) ...[
                                  // Show Cancel Request button for sender
                                  BlocBuilder<ConnectionConnectCubit, ConnectionConnectState>(
                                    builder: (context, connectState) {
                                      final isCancelling = connectState is ConnectionConnectLoading && 
                                                         connectState.userId == connection.id;
                                      return ElevatedButton(
                                        onPressed: isCancelling
                                            ? null
                                            : () {
                                                context.read<ConnectionConnectCubit>().handleConnection(connection.id, isCancel: true).then((_) {
                                                  // Refresh connections after cancelling
                                                  context.read<LocalConnectionsCubit>().loadConnections();
                                                });
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: isCancelling
                                            ? const SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              )
                                            : const Text(
                                                'Cancel Request',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                      );
                                    },
                                  ),
                                ] else ...[
                                  // Show Accept and Reject buttons for receiver
                                  Row(
                                    children: [
                                      BlocBuilder<ConnectionConnectCubit, ConnectionConnectState>(
                                        builder: (context, connectState) {
                                          final isAccepting = connectState is ConnectionConnectLoading && 
                                                            connectState.userId == connection.connectionStatus.connectionId.toString();
                                          return ElevatedButton(
                                            onPressed: isAccepting
                                                ? null
                                                : () {
                                                    context.read<ConnectionConnectCubit>().acceptConnection(connection.connectionStatus.connectionId.toString()).then((_) {
                                                      // Refresh connections after accepting
                                                      context.read<LocalConnectionsCubit>().loadConnections();
                                                    });
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 77, 216, 82),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: isAccepting
                                                ? const SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Accept',
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      BlocBuilder<ConnectionConnectCubit, ConnectionConnectState>(
                                        builder: (context, connectState) {
                                          final isRejecting = connectState is ConnectionConnectLoading && 
                                                           connectState.userId == connection.connectionStatus.connectionId.toString();
                                          return ElevatedButton(
                                            onPressed: isRejecting
                                                ? null
                                                : () {
                                                    context.read<ConnectionConnectCubit>().rejectConnection(connection.connectionStatus.connectionId.toString()).then((_) {
                                                      // Refresh connections after rejecting
                                                      context.read<LocalConnectionsCubit>().loadConnections();
                                                    });
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 8,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: isRejecting
                                                ? const SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    'Reject',
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(width: 180, height: 20),
              ShimmerWidget(width: 60, height: 20),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(right: 12),
                child: ShimmerWidget(width: 160, height: 160),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
