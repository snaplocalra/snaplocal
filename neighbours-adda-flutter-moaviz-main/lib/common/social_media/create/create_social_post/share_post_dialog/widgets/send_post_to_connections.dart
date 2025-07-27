import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/create/create_social_post/share_post_dialog/widgets/share_post_dialog_profile.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/profile/connections/logic/profile_connection/profile_connection_cubit.dart';
import 'package:snap_local/profile/connections/models/profile_connection_list_model.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SendPostToConnections extends StatefulWidget {
  const SendPostToConnections({super.key});

  @override
  State<SendPostToConnections> createState() => _SendPostToConnectionsState();
}

class _SendPostToConnectionsState extends State<SendPostToConnections> {
  final connectionScrollController = ScrollController();

  late ProfileConnectionsCubit profileConnectionsCubit =
      ProfileConnectionsCubit(ProfileConnectionRepository());

  @override
  void initState() {
    super.initState();

    profileConnectionsCubit.fetchConnections(
      profileConnectionType: ProfileConnectionType.myConnections,
    );

    connectionScrollController.addListener(() {
      if (connectionScrollController.position.maxScrollExtent ==
          connectionScrollController.offset) {
        profileConnectionsCubit.fetchConnections(
          loadMoreData: true,
          profileConnectionType: ProfileConnectionType.myConnections,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 220,
      ),
      child: BlocProvider.value(
        value: profileConnectionsCubit,
        child: BlocBuilder<ProfileConnectionsCubit, ProfileConnectionsState>(
          builder: (context, profileConnectionsState) {
            if (profileConnectionsState.isMyConenctionDataLoading) {
              return const CircleCardShimmerListBuilder(
                padding: EdgeInsets.symmetric(vertical: 15),
              );
            } else {
              final connectionsList =
                  profileConnectionsState.connectionListModel.myConnections;
              final logs = connectionsList.data;

              //Connection list
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SearchTextField(
                        dataLoading: profileConnectionsState.isSearching,
                        hint: LocaleKeys.search,
                        onQuery: (query) {
                          final connectionCubit =
                              context.read<ProfileConnectionsCubit>();
                          if (query.isNotEmpty) {
                            connectionCubit.setSearchQuery(query);
                            //Search connections
                            connectionCubit.searchConenctionByType(
                              profileConnectionType:
                                  ProfileConnectionType.myConnections,
                            );
                          } else {
                            connectionCubit.clearSearchQuery();
                            //Fetch the connections with the last selected connection type
                            connectionCubit.fetchConnections(
                              profileConnectionType:
                                  ProfileConnectionType.myConnections,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  logs.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              tr(LocaleKeys.noConnectionFound),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Flexible(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            shrinkWrap: true,
                            controller: connectionScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: logs.length + 1,
                            itemBuilder: (context, index) {
                              if (index < logs.length) {
                                final people = logs[index];

                                return BlocProvider(
                                  create: (context) => ChatControllerCubit(
                                      dataUploadStatusCubit:
                                          DataUploadStatusCubit(),
                                      firebaseChatRepository: context
                                          .read<FirebaseChatRepository>()),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child:
                                        _ConnectionContactCard(people: people),
                                  ),
                                );
                              } else {
                                if (connectionsList
                                    .paginationModel.isLastPage) {
                                  return const SizedBox.shrink();
                                } else {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                    child: ThemeSpinner(size: 20),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _ConnectionContactCard extends StatelessWidget {
  const _ConnectionContactCard({required this.people});

  final ProfileConnectionModel people;

  @override
  Widget build(BuildContext context) {
    final post = context.read<PostDetailsControllerCubit>().socialPostModel;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SharePostDialogProfileWidget(
            image: people.requestedUserImage,
            name: people.requestedUserName,
            address: people.address,
          ),
        ),

        //Send button
        BlocBuilder<ChatControllerCubit, ChatControllerState>(
          builder: (context, chatControllerState) {
            return chatControllerState.messageSendLoading
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: ThemeSpinner(size: 25),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: chatControllerState.isSendMessageRequestSuccess
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              tr(LocaleKeys.sent),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: chatControllerState.messageSendLoading
                                ? null
                                : () {
                                    //Send post to connection
                                    context
                                        .read<ChatControllerCubit>()
                                        .sendExternalChatMessage(
                                          receiverUserId:
                                              people.requestedUserId,
                                          message: "",
                                          socialPostModel: post,
                                          messageType: MessageType.post,
                                        );
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ApplicationColours.themeLightPinkColor,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 4,
                              ),
                              child: Text(
                                //
                                tr(LocaleKeys.send),
                                style: TextStyle(
                                  color: ApplicationColours.themeLightPinkColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                  );
          },
        ),
      ],
    );
  }
}
