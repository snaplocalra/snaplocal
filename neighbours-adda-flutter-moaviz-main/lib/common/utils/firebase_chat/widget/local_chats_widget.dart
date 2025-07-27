import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:convert';

import 'package:designer/widgets/show_snak_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geohash_plus/geohash_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/blocked_users/local_chat_blocked_users_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chat_flaged_count/local_chat_flaged_count_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chat_flaged_count/local_chat_flaged_count_state.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_state.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/active_users/active_users_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/reply_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/search_state_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chat_blocked_users_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chats_repository.dart';
import 'package:snap_local/profile/connections/logic/profile_connection_action/profile_connection_action_cubit.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/report_local_chat_spam_user_screen.dart';
import 'package:flutter/rendering.dart';

import '../../../../profile/profile_details/own_profile/screen/own_profile_screen.dart';
import '../../../../profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import '../../../../profile/profile_settings/models/profile_settings_model.dart';
import '../../../../profile/profile_settings/repository/profile_settings_repository.dart';
import '../../../../utility/tools/theme_divider.dart';
import '../constant/firebase_table_name.dart';

class LocalChatsWidget extends StatefulWidget {
  final ProfileConnectionActionCubit? profileConnectionActionCubit;

  const LocalChatsWidget({
    super.key,
    this.profileConnectionActionCubit,
  });

  @override
  State<LocalChatsWidget> createState() => _LocalChatsWidgetState();
}

class _LocalChatsWidgetState extends State<LocalChatsWidget>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _userId;
  final GlobalKey _screenKey = GlobalKey();
  String? _cachedScreenshot;

  late ProfileConnectionActionCubit profileConnectionActionCubit =
      widget.profileConnectionActionCubit ??
          ProfileConnectionActionCubit(
            connectionRepository: ProfileConnectionRepository(),
          );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _searchController.addListener(() {
      final hasText = _searchController.text.isNotEmpty;
      context.read<SearchStateCubit>().updateSearchState(hasText);
    });

    final profileState = context.read<ManageProfileDetailsBloc>().state;
    _userId = profileState.profileDetailsModel?.id ?? "";
    final profileImage = profileState.profileDetailsModel?.profileImage ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_userId != null && _userId!.isNotEmpty) {
        context.read<LocalChatsCubit>().setCurrentUserId(_userId!);
        context.read<LocalChatFlagedCountCubit>().startListening(_userId!);
        LocalChatsActiveUsersRepository().setUserActive(_userId!, profileImage);
      }

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    if (_userId != null && _userId!.isNotEmpty) {
      LocalChatsActiveUsersRepository().setUserInactive(_userId!);
      context.read<LocalChatBlockedUsersCubit>().close();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_userId == null || _userId!.isEmpty) return;

    final profileImage = context.read<ManageProfileDetailsBloc>().state.profileDetailsModel?.profileImage ?? "";

    if (state == AppLifecycleState.resumed) {
      LocalChatsActiveUsersRepository().setUserActive(_userId!, profileImage);
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      LocalChatsActiveUsersRepository().setUserInactive(_userId!);
    }
  }

  void _captureAndNavigateToReport(
      BuildContext context, String userId, String reportMessage) {
    if (_cachedScreenshot != null) {
      GoRouter.of(context).pushNamed(
        ReportLocalChatSpamUserScreen.routeName,
        pathParameters: {
          'userId': userId,
          'reportMessage': Uri.encodeComponent(reportMessage)
        },
        extra: _cachedScreenshot,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boundary = _screenKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary != null) {
        boundary.toImage().then((image) {
          image.toByteData(format: ImageByteFormat.png).then((byteData) {
            if (byteData != null) {
              final bytes = byteData.buffer.asUint8List();
              final base64Image = base64Encode(bytes);

              _cachedScreenshot = base64Image;

              GoRouter.of(context).pushNamed(
                ReportLocalChatSpamUserScreen.routeName,
                pathParameters: {
                  'userId': userId,
                  'reportMessage': Uri.encodeComponent(reportMessage)
                },
                extra: base64Image,
              );
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalChatBlockedUsersCubit>(
          create: (context) => LocalChatBlockedUsersCubit(
            LocalChatBlockedUsersRepository(),
          )..startListening(_userId ?? ''),
        ),
        BlocProvider(
          create: (context) {
            final cubit = LocalChatsCubit(
              repository: LocalChatsRepository(),
              blockedUsersRepo: LocalChatBlockedUsersRepository(),
            );
            if (_userId != null && _userId!.isNotEmpty) {
              cubit.setCurrentUserId(_userId!);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) =>
              ActiveUsersCubit(LocalChatsActiveUsersRepository()),
        ),
        BlocProvider(create: (context) => SearchStateCubit()),
        BlocProvider(create: (context) => ReplyCubit()),
      ],
      child: Container(
        color: Colors.white,
        child: RepaintBoundary(
          key: _screenKey,
          child: ChatContentWidget(
            profileConnectionActionCubit: profileConnectionActionCubit,
            scrollController: _scrollController,
            searchController: _searchController,
            userId: _userId,
            onReport: (userId, reportMessage) =>
                _captureAndNavigateToReport(context, userId, reportMessage),
          ),
        ),
      ),
    );
  }
}


class ChatContentWidget extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;
  final String? userId;
  final Function(String, String) onReport;
  final ProfileConnectionActionCubit profileConnectionActionCubit;

  const ChatContentWidget(
      {super.key,
      required this.scrollController,
      required this.searchController,
      required this.userId,
      required this.onReport,
      required this.profileConnectionActionCubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: BlocBuilder<LocalChatsCubit, LocalChatsState>(
            builder: (context, state) {
              return SizedBox(
                height: 40,
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search messages...',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    context.read<LocalChatsCubit>().filterChats(value);
                  },
                ),
              );
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<LocalChatsCubit, LocalChatsState>(
            builder: (context, state) {
              switch (state.status) {
                case LocalChatsStatus.loading:
                  return const Center(child: CircularProgressIndicator());

                case LocalChatsStatus.error:
                  return Center(
                      child: Text(state.errorMessage ?? 'An error occurred'));

                case LocalChatsStatus.loaded:
                  final chats = state.searchQuery?.isNotEmpty == true
                      ? state.filteredChats
                      : state.chats;

                  if (chats.isEmpty) {
                    return Center(
                      child: Text(
                        state.searchQuery?.isNotEmpty == true
                            ? 'No messages found'
                            : 'No local chats yet',
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ChatMessageTile(
                        chat: chat,
                        pre: index==0?chat:chats[index-1],
                        onReport: onReport,
                        localUserId: userId ?? '',
                        index: index,
                        profileConnectionActionCubit:
                            profileConnectionActionCubit, // Pass the userId from parent
                      );
                    },
                  );

                default:
                  return const SizedBox();
              }
            },
          ),
        ),
        BlocBuilder<ActiveUsersCubit, List<ActiveUserModel>>(
          builder: (context, users) {
            if (users.isEmpty) return const SizedBox.shrink();
            final showMore = users.length > 10;
            final displayUsers = showMore ? users.take(10).toList() : users;
            return SizedBox(
              height: 65,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: displayUsers.length + (showMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (showMore && index == 10) {
                    return GestureDetector(
                      onTap: () {
                        _showAllActiveUsersDialog(context, users);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue,
                            child: Text(
                              '+${users.length - 10}\n More',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final user = displayUsers[index];
                  return GestureDetector(
                    onTap: () => _navigateToUserProfile(context, user.userId,userId),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundImage: user.profileImage.isNotEmpty
                                  ? NetworkImage(user.profileImage)
                                  : null,
                              child: user.profileImage.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        BlocBuilder<LocalChatFlagedCountCubit, LocalChatFlagedCountState>(
          builder: (context, flagState) {
            return MessageInputWidget(
              isDisabled: !flagState.hasAccess,
              message: flagState.message.toString(),
            );
          },
        ),
      ],
    );
  }

  void _showAllActiveUsersDialog(
      BuildContext context, List<ActiveUserModel> users) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Dialog content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'All Active Users (${users.length})',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300, // Adjust as needed
                      width: 300, // Adjust as needed
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return GestureDetector(
                            onTap: () => _navigateToUserProfile(context, user.userId,userId),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: user.profileImage.isNotEmpty
                                      ? NetworkImage(user.profileImage)
                                      : null,
                                  child: user.profileImage.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Close icon (top right, outside content)
              Positioned(
                top: -7,
                right: -7,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToUserProfile(BuildContext context, String userId,String? localUserId) async {
    if(localUserId==userId){
      await GoRouter.of(context).pushNamed(OwnProfilePostsScreen.routeName);
    }
    else {
      GoRouter.of(context).pushNamed(
      NeighboursProfileAndPostsScreen.routeName,
      queryParameters: {'id': userId},
    );
    }
  }
}

class ChatMessageTile extends StatelessWidget {
  final LocalChatModel chat;
  final LocalChatModel pre;
  final Function(String, String) onReport;
  final String localUserId; // Changed from AuthenticationTokenSharedPref
  final int index; // Changed from AuthenticationTokenSharedPref

  ProfileConnectionActionCubit profileConnectionActionCubit;

  ChatMessageTile(
      {super.key,
      required this.chat,
      required this.onReport,
      required this.localUserId,
      required this.profileConnectionActionCubit, required this.index, required this.pre});

  void _navigateToUserProfile(BuildContext context, String userId) {

    GoRouter.of(context).pushNamed(
      NeighboursProfileAndPostsScreen.routeName,
      queryParameters: {'id': userId},
    );
  }
  void _navigateToOwnProfile(BuildContext context, String userId) async{

    await GoRouter.of(context).pushNamed(OwnProfilePostsScreen.routeName);

  }

  // void _showEmojiPicker(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => EmojiPickerWidget(
  //       onEmojiSelected: (emoji) {
  //         if (chat.id != null) {
  //           print('Adding emoji reaction: ${emoji.emoji} to chat: ${chat.id}');
  //           context.read<LocalChatsCubit>().addEmojiReaction(
  //                 chat.id!,
  //                 emoji.emoji,
  //                 chat.senderId,
  //               );
  //         }
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }

  void _showEmojiPicker(BuildContext context) {
    // Get the cubit before showing the dialog
    final localChatsCubit = context.read<LocalChatsCubit>();

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => EmojiPickerWidget(
        onEmojiSelected: (emoji) {
          if (chat.id != null) {
            print('Adding emoji reaction: ${emoji.emoji} to chat: ${chat.id}');
            localChatsCubit.addEmojiReaction(
              chat.id!,
              emoji.emoji,
              chat.senderId,
            );
          }
          Navigator.pop(bottomSheetContext);
        },
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    if (chat.id != null) {
      print("Report dialog initiated for chat: ${chat.id}");
      onReport(chat.senderId, chat.message);
    }
  }

  void _showLongPressOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => Builder(
        builder: (builderContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  // Use the original context to access the ReplyCubit
                  context.read<ReplyCubit>().setReplyTo(chat);
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions_outlined),
                title: const Text('Add Reaction'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _showEmojiPicker(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, bool isBlocked) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => Builder(
        builder: (builderContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  // Use the original context to access the ReplyCubit
                  context.read<ReplyCubit>().setReplyTo(chat);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: Text(isBlocked?'Unblock User':'Block User'),
                onTap: () async {
                  if(isBlocked){
                    try {
                      // final blockedUsersCubit =
                      //     context.read<LocalChatBlockedUsersCubit>();

                      // await blockedUsersCubit.blockUser(
                      //   blockerId: localUserId,
                      //   blockedUserId: chat.senderId,
                      //   blockedUserName: chat.senderName,
                      //   blockedUserProfileImage: chat.senderProfilePathUrl,
                      // );
                      if (localUserId.isNotEmpty) {
                        await profileConnectionActionCubit
                            .toggleBlockUser(chat.senderId);
                        //     .then((_) async {
                        //   print("Block user completed, adding block history");
                        //   final cubit = context.read<LocalChatsCubit>();
                        //   await cubit.addBlockHistory(chat.senderId);
                        // }).catchError((error) {
                        //   print("Error in toggleBlockUser: $error");
                        // });
                      } else {
                        print("Warning: Cannot Ublockb user - currentUserId not set");
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to block user: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                  else {
                    Navigator.pop(context);
                    _showBlockConfirmationDialog(
                        context, profileConnectionActionCubit);
                  }

                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBlockConfirmationDialog(BuildContext context,
      ProfileConnectionActionCubit profileConnectionActionCubit) {
    showDialog(
      context: context,
      builder: (dailogueBContext) => AlertDialog(
        title: const Text('Block User'),
        content: const Text(
            'Are you sure you want to block this user? You will no longer receive messages from them.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // final blockedUsersCubit =
                //     context.read<LocalChatBlockedUsersCubit>();

                // await blockedUsersCubit.blockUser(
                //   blockerId: localUserId,
                //   blockedUserId: chat.senderId,
                //   blockedUserName: chat.senderName,
                //   blockedUserProfileImage: chat.senderProfilePathUrl,
                // );
                if (localUserId.isNotEmpty) {
                  await profileConnectionActionCubit
                      .toggleBlockUser(chat.senderId);
                  //     .then((_) async {
                  //   print("Block user completed, adding block history");
                  //   final cubit = context.read<LocalChatsCubit>();
                  //   await cubit.addBlockHistory(chat.senderId);
                  // }).catchError((error) {
                  //   print("Error in toggleBlockUser: $error");
                  // });
                } else {
                  print("Warning: Cannot block user - currentUserId not set");
                }

                Navigator.pop(dailogueBContext);
              } catch (e) {
                Navigator.pop(dailogueBContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to block user: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = chat.senderId == localUserId;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isCurrentUser) ...[
                GestureDetector(
                  onTap: () => _navigateToUserProfile(context, chat.senderId),
                  child: CircleAvatar(
                    backgroundImage: chat.senderProfilePathUrl.isNotEmpty
                        ? NetworkImage(chat.senderProfilePathUrl)
                        : null,
                    radius: 20,
                    child: chat.senderProfilePathUrl.isEmpty
                        ? Text(chat.senderName[0].toUpperCase())
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onLongPress: () => _showLongPressOptions(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (chat.replyParentMessage != null &&
                            chat.replyParentUsername != null)
                          MessageReplyPreview(
                            parentMessage: chat.replyParentMessage!,
                            parentUsername: chat.replyParentUsername!,
                          ),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                isCurrentUser ? Colors.blue[100] : Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isCurrentUser ? 16 : 4),
                              bottomRight: Radius.circular(isCurrentUser ? 4 : 16),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isCurrentUser)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () => _navigateToUserProfile(
                                            context, chat.senderId),
                                        child: Text(
                                          chat.senderName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[100],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.more_horiz),
                                        onPressed: () async {
                                          final userData=await getUserData();
                                          bool isBlocked = false;
                                          if(userData!=null&&userData.blockedUsers.contains(chat.senderId)) {
                                            isBlocked=true;
                                          }
                                          _showOptionsMenu(context,isBlocked);
                                        },
                                        iconSize: 16,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 24,
                                          minHeight: 24,
                                        ),
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      chat.message,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8,),
                                  Text(
                                    DateFormat('hh:mm a').format(chat.timestamp.toDate()),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: isCurrentUser
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (chat.emojis.isNotEmpty)
                                  Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: chat.emojis.map((emoji) {
                                      return GestureDetector(
                                        onTap: () async {
                                          final reactedUsers =
                                              await _getReactedUsersForEmoji(
                                                  chat, emoji);
                                          _showReactedUsersDialog(
                                              context, reactedUsers,chat.emojiCount);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Text(
                                            '$emoji ${chat.emojiCount[emoji] ?? 0}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isCurrentUser) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _navigateToOwnProfile(context, chat.senderId),
                  child: CircleAvatar(
                    backgroundImage: chat.senderProfilePathUrl.isNotEmpty
                        ? NetworkImage(chat.senderProfilePathUrl)
                        : null,
                    radius: 20,
                    child: chat.senderProfilePathUrl.isEmpty
                        ? Text(chat.senderName[0].toUpperCase())
                        : null,
                  ),
                ),
              ],
            ],
          ),
        ),
        if(!DateUtils.isSameDay(chat.sentDateTime, pre.sentDateTime))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(238, 237, 238, 1),
            ),
            child: Text(
              getDay(chat.sentDateTime.add(Duration(days: 1))),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(138, 135, 135, 1),
              ),
            ),
          ),
      ],
    );
  }

  String getDay(DateTime messageTime){
    DateTime date=DateTime.now();
    if(DateUtils.isSameDay(date, messageTime))
      return "Today";
    else if(DateUtils.isSameDay(date.subtract(const Duration(days: 1)), messageTime))
      return "Yesterday";
    else
      return DateFormat("EEEE").format(messageTime);
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final dateFormat = 'MMM d, yyyy';
    final timeFormat = 'h:mm a';

    String relativeTime;
    if (difference.inDays > 0) {
      relativeTime = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      relativeTime = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      relativeTime = '${difference.inMinutes}m ago';
    } else {
      relativeTime = 'Just now';
    }

    final formattedDate =
        '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
    final formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return '$relativeTime • $formattedDate $formattedTime';
  }

  Future<FirebaseUserProfileDetailsModel?> getUserData() async {
    final userData = await FirebaseUserRepository().fetchUserData(userId: localUserId);
    return userData;
  }

  Future<List<ReactedUser>> _getReactedUsersForEmoji(LocalChatModel chat, String emoji) async {
    final userIds = chat.emojiSenders.values.toList().expand((item) => item).toList();
    final users = <ReactedUser>[];
    for (final userId in userIds) {
      try {
        ProfileSettingsCubit profileSettingsCubit=ProfileSettingsCubit(ProfileSettingsRepository());
        ProfileSettingsModel profile= await profileSettingsCubit.profileSettingsRepository.fetchProfileSettings();
        // return chats;
        print("------------------------------------------------------");
        print(profile.marketPlaceLocation?.toJson());
        final userData = await FirebaseUserRepository().fetchUserData(userId: userId);
        if (userData != null) {
          users.add(ReactedUser(
            name: userData.name,
            address: profile.marketPlaceLocation?.address??"",
            profileImageUrl: userData.profileImage ?? '',
            emoji: getEmoji(userId),
            userId: userId,
          ));
        }
      } catch (e) {
        // Optionally handle error or add a placeholder user
      }
    }
    return users;
  }

  String getEmoji(String userId){
    var map=chat.emojiSenders.entries.firstWhere((e) => e.value.contains(userId));
    return map.key;
  }

  void _showReactedUsersDialog(BuildContext context, List<ReactedUser> users,Map emojiCount) {
    double height=MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        final emoji = users.isNotEmpty ? users.first.emoji : '';
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            height: height*0.6,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with "All" tab and emoji count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // "All" tab
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: const Text(
                          'All',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Count
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue[900],
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          users.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      // Emoji and count
                      for(var emoji in emojiCount.entries)...[
                        Text(
                          emoji.key,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          emoji.value.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const ThemeDivider(thickness: 2),
                // User list
                Expanded(
                  child: ListView.builder(
                    itemCount:users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => localUserId==user.userId?_navigateToOwnProfile(context, user.userId):_navigateToUserProfile(context, user.userId),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.profileImageUrl),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                user.address,
                                style: const TextStyle(fontSize:12,fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                user.emoji,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const ThemeDivider(thickness: 2),
                        ],
                      );
                    },
                  ),
                ),

                // ...users.map((user) => GestureDetector(
                //       onTap: () => _navigateToUserProfile(context, user.userId),
                //       child: ListTile(
                //         leading: CircleAvatar(
                //           backgroundImage: NetworkImage(user.profileImageUrl),
                //         ),
                //         title: Text(
                //           user.name,
                //           style: const TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //         subtitle: Text(
                //           user.address,
                //           style: const TextStyle(fontSize:12,fontWeight: FontWeight.w500),
                //         ),
                //         trailing: Text(
                //           user.emoji,
                //           style: const TextStyle(fontSize: 22),
                //         ),
                //       ),
                //     )),
                if (users.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('No reactions yet'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MessageReplyPreview extends StatelessWidget {
  final String parentMessage;
  final String parentUsername;

  const MessageReplyPreview({
    super.key,
    required this.parentMessage,
    required this.parentUsername,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: Colors.blue.shade300,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            parentUsername,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            parentMessage,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class EmojiPickerWidget extends StatelessWidget {
  final Function(Emoji) onEmojiSelected;

  const EmojiPickerWidget({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) => onEmojiSelected(emoji),
        config: Config(
          emojiViewConfig: EmojiViewConfig(
            columns: 7,
            emojiSizeMax: 32 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.30
                    : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            recentsLimit: 28,
            noRecents: const Text(
              'No Recents',
              style: TextStyle(fontSize: 20, color: Colors.black26),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            buttonMode: ButtonMode.MATERIAL,
          ),
          categoryViewConfig: CategoryViewConfig(
            initCategory: Category.SMILEYS,
            indicatorColor: ApplicationColours.themeBlueColor,
            iconColor: Colors.grey,
            iconColorSelected: ApplicationColours.themeBlueColor,
            backspaceColor: ApplicationColours.themeBlueColor,
            recentTabBehavior: RecentTabBehavior.RECENT,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
          ),
          skinToneConfig: SkinToneConfig(
            dialogBackgroundColor: Colors.white,
            indicatorColor: Colors.grey,
            enabled: true,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: const Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }
}



class MessageInputWidget extends StatelessWidget {
  final bool isDisabled;
  final String message;

  const MessageInputWidget({
    super.key,
    this.isDisabled = false,
    this.message = '',
  });

  @override
  Widget build(BuildContext context) {
    return  const _MessageInputContent(); // Always show input field

    //   Column(
    //   children: [
    //     // Always show input field, but add warning above if disabled
    //     if (isDisabled)
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    //         child: Text(
    //           message,
    //           style: const TextStyle(color: Colors.red),
    //         ),
    //       ),
    //     const _MessageInputContent(), // Always show input field
    //   ],
    // );
  }
}

class _MessageInputContent extends StatelessWidget {
  const _MessageInputContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyCubit, LocalChatModel?>(
      builder: (context, replyMessage) {
        return Column(
          children: [
            if (replyMessage != null)
              ReplyPreview(
                message: replyMessage,
                onClear: () => context.read<ReplyCubit>().clearReply(),
              ),
            const MessageInputField(),
          ],
        );
      },
    );
  }
}

class ReplyPreview extends StatelessWidget {
  final LocalChatModel message;
  final VoidCallback onClear;

  const ReplyPreview({
    required this.message,
    required this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: Colors.blue,
            margin: const EdgeInsets.only(right: 8),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClear,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageInputField extends StatefulWidget {
  const MessageInputField({super.key, });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _messageController = TextEditingController();
  late final MessageInputCubit _messageInputCubit;

  @override
  void initState() {
    super.initState();
    _messageInputCubit = MessageInputCubit();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageInputCubit.close();
    super.dispose();
  }

  void _onTextChanged() {
    _messageInputCubit.setComposing(_messageController.text.trim().isNotEmpty);
  }


  Future<void> _handleSubmitted(String text,BuildContext context) async {
    if (text.trim().isEmpty) return;

    final flagState = context.read<LocalChatFlagedCountCubit>().state;

    if (!flagState.hasAccess) {
      ShowSnackBar.showSnackBar(
        context,
        "${flagState.message}",
        second: 2,
        error:true,
      );
      return; // Prevent sending
    }

    try {
      final authSharedPref = AuthenticationTokenSharedPref();
      final senderId = await authSharedPref.getUserIdSync();
      final senderData =
      await FirebaseUserRepository().fetchUserData(userId: senderId!);
      // Get reply message if exists
      final replyTo = context.read<ReplyCubit>().state;
      print('Replying to: ${replyTo?.message}');
      print('Sender ID: ${replyTo?.senderId}');
      print('Sender Data: ${senderData?.name}');
      final profileSettings = context.read<ProfileSettingsCubit>();
      print('Profile Location Market Data: ${profileSettings.state.profileSettingsModel?.marketPlaceLocation?.toJson()}');
      print('Profile Location Social Data: ${profileSettings.state.profileSettingsModel?.socialMediaLocation?.toJson()}');
      final geohash = GeoHash.encode(
        profileSettings.state.profileSettingsModel!.marketPlaceLocation!.latitude,
        profileSettings.state.profileSettingsModel!.marketPlaceLocation!.latitude,
        precision: 3,
      );
      print(geohash.hash);
      if (senderData != null) {
        final message = LocalChatModel(
          senderId: senderId!,
          senderName: senderData.name,
          senderProfilePathUrl: senderData.profileImage,
          message: text.trim(),
          timestamp: Timestamp.now(),
          sentDateTime: DateTime.now(),
          emojis: [],
          emojiCount: {},
          emojiSenders: {},
          // Add reply information
          replyParentMessage: replyTo?.message,
          replyParentUsername: replyTo?.senderName,
          replyParentUserId: replyTo?.senderId,
          geoHash: geohash.hash,
          latitude: profileSettings.state.profileSettingsModel?.marketPlaceLocation?.latitude,
          longitude: profileSettings.state.profileSettingsModel?.marketPlaceLocation?.longitude,
        );

        await context.read<LocalChatsCubit>().sendMessage(message);
        _messageController.clear();
        _messageInputCubit.clearInput();
        context.read<ReplyCubit>().clearReply(); // Clear reply after sending
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  void _onEmojiSelected(Emoji emoji) {
    _messageController.text = _messageController.text + emoji.emoji;
    _messageInputCubit.setComposing(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageInputCubit, MessageInputState>(
      bloc: _messageInputCubit,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onSubmitted: (val)=>
                          state.isComposing ? _handleSubmitted(val,context) : null,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: state.isComposing
                              ? ApplicationColours.themeBlueColor
                              : Colors.grey,
                        ),
                        onPressed: state.isComposing
                            ? () => _handleSubmitted(_messageController.text,context)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state.showEmojiPicker)
              EmojiPickerWidget(onEmojiSelected: _onEmojiSelected),
          ],
        );
      },
    );
  }
}

class ReactedUser {
  final String name;
  final String address;
  final String profileImageUrl;
  final String emoji;
  final String userId;
  ReactedUser({
    required this.name,
    required this.address,
    required this.profileImageUrl,
    required this.emoji,
    required this.userId,
  });
}

class LocalChatsActiveUsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //final String _collectionPath = 'local_chats_dev_active_users';

  Future<void> setUserActive(String userId, String profileImage) async {
    LocalChatsCubit localChatsCubit=LocalChatsCubit(repository: LocalChatsRepository(), blockedUsersRepo: LocalChatBlockedUsersRepository());
    await _firestore.collection(FirebasePath.localChatsActiveUsers).doc(userId).set({
      'userId': userId,
      "geoHash": await localChatsCubit.getGetHash(),
      'profileImage': profileImage,
    });
  }

  Future<void> setUserInactive(String userId) async {
    print("Setting user inactive: $userId");
    await _firestore.collection(FirebasePath.localChatsActiveUsers).doc(userId).delete();
  }

  Stream<List<ActiveUserModel>> getActiveUsers(String geoHash)  {
    return _firestore.collection(FirebasePath.localChatsActiveUsers).where("geoHash",isEqualTo: geoHash).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ActiveUserModel.fromJson(doc.data()))
              .toList(),
        );
  }
}

class ActiveUserModel {
  final String userId;
  final String geoHash;
  final String profileImage;

  ActiveUserModel({required this.userId,required this.geoHash, required this.profileImage});

  factory ActiveUserModel.fromJson(Map<String, dynamic> json) {
    return ActiveUserModel(
      userId: json['userId'] ?? '',
      geoHash: json['geoHash'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class ActiveUsersCubit extends Cubit<List<ActiveUserModel>> {
  final LocalChatsActiveUsersRepository repository;
  StreamSubscription? _subscription;

  ActiveUsersCubit(this.repository) : super([]) {
    LocalChatsCubit localChatsCubit=LocalChatsCubit(repository: LocalChatsRepository(), blockedUsersRepo: LocalChatBlockedUsersRepository());
    localChatsCubit.getGetHash().then((val){
      _subscription = repository.getActiveUsers(val).listen((users) {
        emit(users);
      });
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

void addRandomActiveUsersForTesting() {
  final repo = LocalChatsActiveUsersRepository();
  final random = Random();
  for (int i = 0; i < 20; i++) {
    final userId = 'test_user_${random.nextInt(100000)}_$i';
    // You can use a placeholder image or a random avatar service
    final profileImage =
        'https://i.pravatar.cc/150?img=${random.nextInt(70) + 1}';
    repo.setUserActive(userId, profileImage);
  }
}

class MessageInputState {
  final bool isComposing;
  final bool showEmojiPicker;

  MessageInputState({
    this.isComposing = false,
    this.showEmojiPicker = false,
  });

  MessageInputState copyWith({
    bool? isComposing,
    bool? showEmojiPicker,
  }) {
    return MessageInputState(
      isComposing: isComposing ?? this.isComposing,
      showEmojiPicker: showEmojiPicker ?? this.showEmojiPicker,
    );
  }
}

class MessageInputCubit extends Cubit<MessageInputState> {
  MessageInputCubit() : super(MessageInputState());

  void setComposing(bool value) {
    emit(state.copyWith(isComposing: value));
  }

  void toggleEmojiPicker() {
    emit(state.copyWith(showEmojiPicker: !state.showEmojiPicker));
  }

  void clearInput() {
    print('Clearing input');
    emit(state.copyWith(isComposing: false));
  }
}

// Add this method to AuthenticationTokenSharedPref class
class AuthenticationTokenSharedPref {
  // ...existing code...

  Future<String?> getUserIdSync() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getString('user_id') ??
          ""; // or whatever key you use to store the user ID
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }
}
