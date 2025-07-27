// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_contact/chat_contact_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_setting/chat_setting_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/conversation_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_request_status_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_status.dart';
import 'package:snap_local/common/utils/firebase_chat/model/msg_type_enum.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/message_request_status_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_date.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_delete_option_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_contact_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_bubble/message_deleted_bubble.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/chat_message_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_screen_widgets/send_message_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/firebase_chat_user_shimmer.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/message_request_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/other_communication_details_display.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/common/utils/widgets/custom_alert_dialog.dart';
import 'package:snap_local/common/utils/widgets/svg_button_widget.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/logic/neighbours_profile/neighbours_profile_cubit.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/repository/neighbours_profile_posts_repository.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/profile/profile_privacy/screens/profile_privacy_screen.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/common/pop_up_menu/models/pop_up_menu_type.dart';
import 'package:snap_local/utility/common/pop_up_menu/widgets/pop_up_menu_child.dart';
import 'package:snap_local/utility/common/search_box/logic/search/search_cubit.dart';
import 'package:snap_local/utility/common/search_box/logic/show_search_bar/show_search_bar_cubit.dart';
import 'package:snap_local/utility/common/search_box/widget/search_icon.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserId;
  final OtherCommunicationPost? otherCommunicationPost;
  const ChatScreen({
    super.key,
    required this.receiverUserId,
    this.otherCommunicationPost,
  });

  static const routeName = 'chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {

  Future<XFile?> captureImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      print("Camera error: $e");
      return null;
    }
  }
  late bool isOtherCommunicationPost = widget.otherCommunicationPost != null;

  //Firebase chat repository
  final firebaseChatRepository = 
      FirebaseChatRepository(MessageRequestStatusRepository());

  late NeighboursProfileCubit neighboursProfileCubit =
      NeighboursProfileCubit(NeighboursProfileRepository());

  //This variable will contain the communication model when the conversation is initialized
  CommunicationModel? communicationModel;

  final dataUploadStatusCubit = DataUploadStatusCubit();
  late ChatControllerCubit chatControllerCubit = ChatControllerCubit(
    dataUploadStatusCubit: dataUploadStatusCubit,
    firebaseChatRepository: context.read<FirebaseChatRepository>(),
  );

  final ReceivePort _receivePort = ReceivePort();
  static const String downloadId = "chat_file_downloading";
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort sendPort = IsolateNameServer.lookupPortByName(downloadId)!;

    ///sending the data
    sendPort.send([id, status, progress]);
  }

  //User block status variable
  bool senderBlockedReceiver = false;
  bool receiverBlockedSender = false;

  //Chat last delete time
  DateTime? lastChatDeleteTime;

  late ChatSettingCubit chatSettingCubit = ChatSettingCubit(
    firebaseChatRepository: context.read<FirebaseChatRepository>(),
    firebaseChatSettingRepository:
        context.read<FirebaseChatSettingRepository>(),
  );

  @override
  void initState() {
    super.initState();
    //Add the observer for the app life cycle
    WidgetsBinding.instance.addObserver(this);

    //Fetch the neighbours profile
    neighboursProfileCubit.fetchNeighboursProfile(widget.receiverUserId);

    //Initialize the chat conversation
    chatControllerCubit.initConversation(
      receiverUserId: widget.receiverUserId,
      otherCommunicationPost: widget.otherCommunicationPost,
    );

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      downloadId,
    );
    FlutterDownloader.registerCallback(downloadingCallback);

    //Listen for the communication model stream
    FirebaseChatCommunicationRepository()
        .streamCommunicationModel(
      receiverUserId: widget.receiverUserId,
      otherCommunicationPost: widget.otherCommunicationPost,
    )
        .listen(
      (event) async {
        //Assign the updated communication model when communication updated
        communicationModel = event;

        if (communicationModel != null) {
          //Update the last chat delete time when the conversation is initialized
          setTheLastChatDeleteTime(communicationModel!);
        }
      },
    );
  }

  void setTheLastChatDeleteTime(CommunicationModel communication) async {
    final currentUserId = await AuthenticationTokenSharedPref().getUserId();
    lastChatDeleteTime = communication.communicationUsersAnalytics
        .firstWhere((element) => element.userId == currentUserId)
        .lastChatDeleteTime;
  }

  void changeUserStatus(bool isOnline) async {
    if (communicationModel != null) {
      await firebaseChatRepository.updateUserOnlineStatus(
        userId: await AuthenticationTokenSharedPref().getUserId(),
        isOnline: isOnline,
        communicationId: communicationModel!.communicationId,
        isOtherTypeConversation: widget.otherCommunicationPost != null,
      );
    }
  }

  //On AppLife cycle observer, when user left the chat screen,
  //and minimize the app, then set the user status to offline
  //also when the user comes back to the chat screen, then set the user status to online
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        changeUserStatus(false);
        break;

      case AppLifecycleState.resumed:
        changeUserStatus(true);
        break;

      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        break;
    }
  }

  void changeReceiverBlockStatus() {
    chatSettingCubit.toggleUserBlock(widget.receiverUserId);
  }

  void updateMessageRequestStatus(MessageRequestStatus status) {
    //Update the message request status to rejected
    context
        .read<MessageRequestStatusRepository>()
        .updateRequestAcceptStatus(communicationModel!.communicationId, status);
  }

  Future<void> userProfileNavigation() async {
    //open the Neighbours posts and profile
    GoRouter.of(context).pushNamed(NeighboursProfileAndPostsScreen.routeName,
        queryParameters: {'id': widget.receiverUserId});
  }

  //Update the message status to read
  Future<void> updateMessageStatusToRead({
    required String conversationId,
    required CommunicationModel communication,
  }) async {
    await chatControllerCubit.updateMessageStatus(
      communication: communication,
      conversationId: conversationId,
      messageStatusInfo: MessageStatusInfo(
        status: MessageStatus.read,
        time: DateTime.now(),
      ),
      otherCommunicationPost: widget.otherCommunicationPost,
    );
  }

  //Set the communication visibility to true only when the message is sent and
  //the communication is not visible
  Future<void> setCommunicationVisibility(bool visible) async {
    // Check for the communication visibility status for both users
    for (var user in communicationModel!.communicationUsersAnalytics) {
      // If the communication is not visible, then set the communication visibility to true
      if (!user.isCommunicationVisilbe) {
        await FirebaseChatCommunicationRepository().setCommunicationVisibility(
          userId: user.userId,
          communicationId: communicationModel!.communicationId,
          isOtherCommunication: widget.otherCommunicationPost != null,
          visible: visible,
        );
      }
    }
  }

  @override
  void dispose() {
    changeUserStatus(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: dataUploadStatusCubit),
        BlocProvider.value(value: chatSettingCubit),
        BlocProvider.value(value: chatControllerCubit),
        BlocProvider.value(value: neighboursProfileCubit),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => ShowSearchBarCubit()),
        BlocProvider(
          create: (context) => ChatContactCubit(
            firebaseChatContactRepository:
                FirebaseChatCommunicationRepository(),
            firebaseChatRepository: context.read<FirebaseChatRepository>(),
          ),
        ),
        BlocProvider(create: (context) => ReportCubit(ReportRepository())),
      ],
      child: Builder(builder: (context) {
        return BlocListener<ReportCubit, ReportState>(
          listener: (context, reportState) {
            if (reportState.requestSuccess) {
              if (mounted) {
                //Update the message request status to rejected
                updateMessageRequestStatus(MessageRequestStatus.rejected);

                //Block user
                changeReceiverBlockStatus();

                //Close the chat screen
                GoRouter.of(context).pop();
              }
            }
          },
          child: BlocConsumer<ShowSearchBarCubit, ShowSearchBarState>(
            listener: (context, showSearchBarState) {
              if (!showSearchBarState.visible) {
                context.read<SearchCubit>().clearSearchQuery();
              }
            },
            builder: (context, showSearchBarState) {
              return Scaffold(
                extendBody: true,
                backgroundColor: Colors.white,
                appBar: ThemeAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  title: StreamBuilder<FirebaseUserProfileDetailsModel?>(
                    stream: FirebaseUserRepository()
                        .streamUserDetails(userId: widget.receiverUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const FirebaseUserShimmer();
                      } else {
                        final userDetails = snapshot.data;
                        if (userDetails == null) {
                          return Text(
                            tr(LocaleKeys.noUserDetailsFound),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          );
                        } else {
                          return //Stream for the receiver user block the current user
                              StreamBuilder<bool>(
                            stream: context
                                .read<ChatSettingCubit>()
                                .streamReceiverBlockSenderStatus(
                                    receiverUserId: widget.receiverUserId),
                            builder: (context, receiverBlockedSenderSnapshot) {
                              receiverBlockedSender = receiverBlockedSenderSnapshot
                                      .data ??
                                  //If the snapshot data is null, then reassign the old status
                                  receiverBlockedSender;

                              final contactWidget = ChatScreenContactWidget(
                                onTap: userProfileNavigation,
                                name: userDetails.name,
                                image: receiverBlockedSender
                                    ? null
                                    : userDetails.profileImage,
                              );

                              return isOtherCommunicationPost
                                  ? widget.otherCommunicationPost!
                                      .buildContactDetails(
                                      context,
                                      contactWidget,
                                    )
                                  : contactWidget;
                            },
                          );
                        }
                      }
                    },
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SearchIcon(
                        onTap: () {
                          context.read<ShowSearchBarCubit>().toggleVisible();
                        },
                      ),
                    ),
                    //Stream for the current user block the receiver
                    StreamBuilder<bool>(
                        stream: context
                            .read<ChatSettingCubit>()
                            .streamSenderBlockReceiverStatus(
                                receiverUserId: widget.receiverUserId),
                        builder: (context, _) {
                          return PopupMenuButton<PopUpMenuType>(
                            icon: const SvgButtonWidget(
                              svgImage: SVGAssetsImages.moreDot,
                              svgSize: 25,
                            ),
                            padding: const EdgeInsets.all(2),
                            iconSize: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSelected: (value) {
                              //close the keyboard
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (value == PopUpMenuType.block) {
                                //Block the user
                                changeReceiverBlockStatus();

                                //Update the message request status to rejected
                                updateMessageRequestStatus(
                                    MessageRequestStatus.rejected);
                              } else if (value == PopUpMenuType.unBlock) {
                                changeReceiverBlockStatus();

                                //Update the message request status to accepted
                                updateMessageRequestStatus(
                                    MessageRequestStatus.accepted);
                              } else if (value ==
                                  PopUpMenuType.blockAndReport) {
                                //Open the report screen
                                GoRouter.of(context).pushNamed(
                                  ReportScreen.routeName,
                                  extra: ChatReportPayload(
                                    userId: widget.receiverUserId,
                                    reportCubit: context.read<ReportCubit>(),
                                  ),
                                );
                              } else if (value == PopUpMenuType.delete) {
                                if (communicationModel != null) {
                                  //Delete chat
                                  final chatContactCubit =
                                      context.read<ChatContactCubit>();
                                  showCustomAlertDialog(context,
                                      svgImagePath: SVGAssetsImages.chatFill,
                                      // title: "Confirm Deletion",
                                      title: tr(LocaleKeys.confirmDeletion),
                                      description: tr(LocaleKeys
                                          .areyousureyouwanttodeletethischatconversation),
                                      action: BlocConsumer<ChatContactCubit,
                                          ChatContactState>(
                                        bloc: chatContactCubit,
                                        listener: (context, chatContactState) {
                                          if (chatContactState
                                              .chatDeleteSuccess) {
                                            Navigator.of(context).pop(true);
                                          }
                                        },
                                        builder: (context, chatContactState) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ThemeElevatedButton(
                                                showLoadingSpinner:
                                                    chatContactState
                                                        .chatDeleteLoading,
                                                buttonName: tr(LocaleKeys.yes),
                                                textFontSize: 12,
                                                padding: EdgeInsets.zero,
                                                width: 110,
                                                height: 33,
                                                onPressed: () async {
                                                  await chatContactCubit
                                                      .deleteChat(
                                                    communicationModel:
                                                        communicationModel!,
                                                    isOtherCommunication: widget
                                                            .otherCommunicationPost !=
                                                        null,
                                                  );
                                                },
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    ApplicationColours
                                                        .themePinkColor,
                                              ),
                                              ThemeElevatedButton(
                                                disableButton: chatContactState
                                                    .chatDeleteLoading,
                                                buttonName:
                                                    tr(LocaleKeys.cancel),
                                                textFontSize: 12,
                                                padding: EdgeInsets.zero,
                                                width: 110,
                                                height: 33,
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // Keep editing
                                                },
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    ApplicationColours
                                                        .themeBlueColor,
                                              ),
                                            ],
                                          );
                                        },
                                      ));
                                }
                              }
                              //clear chat
                              else if (value == PopUpMenuType.clear) {
                                if (communicationModel != null) {
                                  //Clear chat
                                  final chatContactCubit =
                                      context.read<ChatContactCubit>();
                                  showCustomAlertDialog(context,
                                      svgImagePath: SVGAssetsImages.chatFill,
                                      title: tr(LocaleKeys.confirmClear),
                                      description: tr(LocaleKeys
                                          .areyousureyouwanttoclearthischatconversation),
                                      action: BlocConsumer<ChatContactCubit,
                                          ChatContactState>(
                                        bloc: chatContactCubit,
                                        listener: (context, chatContactState) {
                                          if (chatContactState
                                              .chatCleanSuccess) {
                                            Navigator.of(context).pop(true);
                                          }
                                        },
                                        builder: (context, chatContactState) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ThemeElevatedButton(
                                                showLoadingSpinner:
                                                    chatContactState
                                                        .chatCleanLoading,
                                                buttonName: tr(LocaleKeys.yes),
                                                textFontSize: 12,
                                                padding: EdgeInsets.zero,
                                                width: 128,
                                                height: 33,
                                                onPressed: () async {
                                                  await chatContactCubit
                                                      .clearChat(
                                                    communicationModel:
                                                        communicationModel!,
                                                    isOtherCommunication: widget
                                                            .otherCommunicationPost !=
                                                        null,
                                                  );
                                                },
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    ApplicationColours
                                                        .themePinkColor,
                                              ),
                                              ThemeElevatedButton(
                                                disableButton: chatContactState
                                                    .chatCleanLoading,
                                                buttonName:
                                                    tr(LocaleKeys.cancel),
                                                textFontSize: 12,
                                                padding: EdgeInsets.zero,
                                                width: 128,
                                                height: 33,
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // Keep editing
                                                },
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    ApplicationColours
                                                        .themeBlueColor,
                                              ),
                                            ],
                                          );
                                        },
                                      )).then((value) {
                                    if (value) {
                                      //refresh the chat screen
                                      setState(() {});
                                    }
                                  });
                                }
                              }
                            },
                            itemBuilder: (context) => [
                              senderBlockedReceiver
                                  ? const PopupMenuItem(
                                      height: 30,
                                      value: PopUpMenuType.unBlock,
                                      child: PopUpMenuChild(
                                        popUpMenuType: PopUpMenuType.unBlock,
                                      ),
                                    )
                                  : const PopupMenuItem(
                                      height: 30,
                                      value: PopUpMenuType.block,
                                      child: PopUpMenuChild(
                                        popUpMenuType: PopUpMenuType.block,
                                      ),
                                    ),

                              //Block and report user
                              if (!senderBlockedReceiver)
                                PopupMenuItem(
                                  height: 30,
                                  value: PopUpMenuType.blockAndReport,
                                  child: PopUpMenuChild(
                                    popUpMenuType: PopUpMenuType.blockAndReport,
                                    prefix: SvgPicture.asset(
                                      SVGAssetsImages.blockAndReport,
                                      height: 15,
                                      width: 15,
                                      colorFilter: ColorFilter.mode(
                                        ApplicationColours.themeBlueColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),

                              //Clear chat
                              PopupMenuItem(
                                height: 30,
                                value: PopUpMenuType.clear,
                                child: PopUpMenuChild(
                                  popUpMenuType: PopUpMenuType.clear,
                                  text: tr(LocaleKeys.clearChat),
                                  //prefix: Icon(Icons.clear,color: ApplicationColours.themeBlueColor,size: 18,),
                                  prefix: SvgPicture.asset(
                                    SVGAssetsImages.clearChat,
                                    height: 18,
                                    width: 18,
                                    colorFilter: ColorFilter.mode(
                                      ApplicationColours.themeBlueColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),

                              //Delete chat
                              PopupMenuItem(
                                height: 30,
                                value: PopUpMenuType.delete,
                                child: PopUpMenuChild(
                                  popUpMenuType: PopUpMenuType.delete,
                                  text: tr(LocaleKeys.deleteChat),
                                  prefix: SvgPicture.asset(
                                    SVGAssetsImages.delete,
                                    height: 17,
                                    width: 17,
                                    colorFilter: ColorFilter.mode(
                                      ApplicationColours.themeBlueColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
                body: BlocListener<ChatContactCubit, ChatContactState>(
                  listener: (context, chatContactState) {
                    if (chatContactState.chatDeleteSuccess) {
                      if (mounted) {
                        //Close the chat screen
                        GoRouter.of(context).pop();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      //full Background image
                      Image.asset(
                        AssetsImages.chatBackgroud,
                        fit: BoxFit.cover,
                        height: mqSize.height,
                        width: mqSize.width,
                      ),

                      BlocBuilder<DataUploadStatusCubit, DataUploadStatusState>(
                        builder: (context, dataUploadStatusState) {
                          return BlocConsumer<ChatControllerCubit,
                                  ChatControllerState>(
                              listener: (context, chatControllerState) async {
                            if (chatControllerState
                                .isCommunicationInitialized) {
                              final currentUserId =
                                  await AuthenticationTokenSharedPref()
                                      .getUserId();
                              final communication =
                                  chatControllerState.communicationModel!;

                              //set the last chat delete time
                              setTheLastChatDeleteTime(communication);

                              //Set the user status to online
                              await firebaseChatRepository
                                  .updateUserOnlineStatus(
                                userId: currentUserId,
                                isOnline: true,
                                communicationId: communication.communicationId,
                                isOtherTypeConversation:
                                    widget.otherCommunicationPost != null,
                              );

                              //Set the unseen count to 0
                              await firebaseChatRepository.setUnseenCountToZero(
                                userId: currentUserId,
                                communicationId: communication.communicationId,
                                isOtherTypeConversation:
                                    widget.otherCommunicationPost != null,
                              );
                            }
                          }, builder: (context, chatControllerState) {
                            if (chatControllerState.chatInitLoading) {
                              return const ThemeSpinner(size: 40);
                            } else {
                              communicationModel =
                                  chatControllerState.communicationModel!;

                              //Only render when the conversation model initialized
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      Visibility(
                                        visible: showSearchBarState.visible,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 4, 8, 0),
                                          child: SearchTextField(
                                            hint: LocaleKeys.search,
                                            onQuery: (query) {
                                              if (query.isNotEmpty) {
                                                //Search chats
                                                context
                                                    .read<SearchCubit>()
                                                    .setSearchQuery(query);
                                              } else {
                                                context
                                                    .read<SearchCubit>()
                                                    .clearSearchQuery();
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                      if (widget.otherCommunicationPost != null)
                                        OtherCommunicationDetailsDisplay(
                                          otherCommunicationPost:
                                              widget.otherCommunicationPost!,
                                        ),

                                      //First profile view
                                      StreamBuilder<MessageRequestStatusModel>(
                                        stream: context
                                            .read<
                                                MessageRequestStatusRepository>()
                                            .messageRequestStatusStream(
                                                communicationModel!
                                                    .communicationId),
                                        builder: (context,
                                            senderBlockedReceiverSnapshot) {
                                          final messageStatusData =
                                              senderBlockedReceiverSnapshot
                                                  .data;

                                          final isReceiver = messageStatusData
                                                  ?.requestSender ==
                                              widget.receiverUserId;
                                          if (senderBlockedReceiverSnapshot
                                                      .connectionState ==
                                                  ConnectionState.active &&
                                              messageStatusData != null &&
                                              messageStatusData.status ==
                                                  MessageRequestStatus
                                                      .pending &&
                                              isReceiver) {
                                            return BlocBuilder<
                                                    NeighboursProfileCubit,
                                                    NeighboursProfileState>(
                                                builder: (context,
                                                    neighboursProfileState) {
                                              final userDetails =
                                                  neighboursProfileState
                                                      .neighboursProfileModel
                                                      ?.profileDetailsModel;

                                              if (userDetails != null) {
                                                return AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  transitionBuilder:
                                                      (child, animation) {
                                                    return ScaleTransition(
                                                      scale: animation,
                                                      child: child,
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        OctagonWidget(
                                                          shapeSize: 100,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: userDetails
                                                                .profileImage,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Text(
                                                          userDetails.name,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        if (userDetails
                                                                .location !=
                                                            null)
                                                          Wrap(
                                                            alignment:
                                                                WrapAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color: ApplicationColours
                                                                    .themeBlueColor,
                                                                size: 14,
                                                              ),
                                                              Text(
                                                                userDetails
                                                                    .location!
                                                                    .address,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            });
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),

                                      //--------------------------------------------

                                      Expanded(child:
                                          BlocBuilder<SearchCubit, SearchState>(
                                        builder: (context, chatSearchState) {
                                          return StreamBuilder<
                                              Map<String,
                                                  List<ConversationModel>>?>(
                                            stream: context
                                                .read<ChatControllerCubit>()
                                                .streamConversationMessages(
                                                  lastChatDeleteTime:
                                                      lastChatDeleteTime,
                                                  communicationId:
                                                      communicationModel!
                                                          .communicationId,
                                                  query: chatSearchState.query,
                                                  otherCommunicationPost: widget
                                                      .otherCommunicationPost,
                                                ),
                                            builder: (context,
                                                conversationSnapshot) {
                                              if (conversationSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const ThemeSpinner(
                                                    size: 40);
                                              } else {
                                                final chatDateLogs =
                                                    conversationSnapshot.data;
                                                if (chatDateLogs == null ||
                                                    chatDateLogs.keys.isEmpty) {
                                                  return Center(
                                                    child: Text(tr(LocaleKeys
                                                        .noChatFoundStartChatting)),
                                                  );
                                                } else {
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    reverse: true,
                                                    keyboardDismissBehavior:
                                                        ScrollViewKeyboardDismissBehavior
                                                            .onDrag,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount:
                                                        chatDateLogs.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int chatDateIndex) {
                                                      String? date = chatDateLogs
                                                          .keys
                                                          .elementAt(chatDateIndex);
                                                      List<ConversationModel>
                                                          chatMessages =
                                                          chatDateLogs[date] ??
                                                              [];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Column(
                                                            children: [
                                                              ChatDate(
                                                                  date: date),
                                                              const SizedBox(
                                                                  height: 10),
                                                              ListView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                reverse: true,
                                                                itemCount:
                                                                    chatMessages
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        messageIndex) {
                                                                  final conversationData =
                                                                      chatMessages[
                                                                          messageIndex];

                                                                  //If the message is deleted only for the current user
                                                                  final messageDeleteForReceiver = conversationData
                                                                      .deletedFor
                                                                      .contains(
                                                                          conversationData
                                                                              .receiverId);

                                                                  final messageDeleteForSender = conversationData
                                                                          .deletedFor
                                                                          .contains(conversationData
                                                                              .senderId) &&
                                                                      conversationData
                                                                          .isCurrentUser;

                                                                  ////
                                                                  //Only receiver user can update the message status to read
                                                                  //when the message is not deleted for the receiver
                                                                  if (!conversationData
                                                                          .isCurrentUser &&
                                                                      conversationData
                                                                              .messageStatusInfo
                                                                              .status ==
                                                                          MessageStatus
                                                                              .sent &&
                                                                      !messageDeleteForReceiver) {
                                                                    updateMessageStatusToRead(
                                                                      conversationId:
                                                                          conversationData
                                                                              .conversationId!,
                                                                      communication:
                                                                          communicationModel!,
                                                                    );
                                                                  }
                                                                  ////
                                                                  return messageDeleteForReceiver ||
                                                                          messageDeleteForSender
                                                                      ? MessageDeletedBubble(
                                                                          tail:
                                                                              true,
                                                                          text: conversationData.isCurrentUser
                                                                              ? "You deleted this message"
                                                                              : "This message was deleted",
                                                                          isSender:
                                                                              conversationData.isCurrentUser,
                                                                          color: conversationData.isCurrentUser
                                                                              ? const Color.fromRGBO(0, 92, 75, 1)
                                                                              : const Color.fromRGBO(32, 44, 51, 1),
                                                                        )
                                                                      : GestureDetector(
                                                                          onLongPress: conversationData.isCurrentUser
                                                                              ? () {
                                                                                  showModalBottomSheet(
                                                                                    context: context,
                                                                                    builder: (_) {
                                                                                      return ChatDeleteOptionWidget(
                                                                                        onDeleteForEveryone: conversationData.messageSentWhenBlocked
                                                                                            ? null
                                                                                            : () {
                                                                                                context.read<ChatControllerCubit>().deleteMessage(
                                                                                                      communicationModel: communicationModel!,
                                                                                                      conversationModel: conversationData,
                                                                                                      receiverUserId: widget.receiverUserId,
                                                                                                      isDeleteForMe: false,
                                                                                                      isLastMessage: messageIndex == 0, //Here 0 index is the last sent message
                                                                                                      otherCommunicationPost: widget.otherCommunicationPost,
                                                                                                    );
                                                                                              },
                                                                                        onDeleteForMe: () {
                                                                                          context.read<ChatControllerCubit>().deleteMessage(
                                                                                                communicationModel: communicationModel!,
                                                                                                conversationModel: conversationData,
                                                                                                receiverUserId: widget.receiverUserId,
                                                                                                isDeleteForMe: true,
                                                                                                otherCommunicationPost: widget.otherCommunicationPost,
                                                                                              );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }
                                                                              : null,
                                                                          child:
                                                                              ChatMessageWidget(
                                                                            key:
                                                                                Key(messageIndex.toString()),
                                                                            conversationModel:
                                                                                conversationData,
                                                                            isCurrentUser:
                                                                                conversationData.isCurrentUser,
                                                                          ),
                                                                        );
                                                                },
                                                              ),
                                                            ]),
                                                      );
                                                    },
                                                  );
                                                }
                                              }
                                            },
                                          );
                                        },
                                      )),
                                      //Stream for the current user block the receiver
                                      SafeArea(
                                        child: StreamBuilder<bool>(
                                          stream: context
                                              .read<ChatSettingCubit>()
                                              .streamSenderBlockReceiverStatus(
                                              receiverUserId:
                                              widget.receiverUserId),
                                          builder: (context,
                                              senderBlockedReceiverSnapshot) {
                                            senderBlockedReceiver =
                                                senderBlockedReceiverSnapshot
                                                    .data ??
                                                    false;
                                            return senderBlockedReceiver
                                                ? GestureDetector(
                                              onTap: () {
                                                changeReceiverBlockStatus();

                                                //change message request status to accepted
                                                updateMessageRequestStatus(
                                                    MessageRequestStatus
                                                        .accepted);
                                              },
                                              child: Container(
                                                padding:
                                                const EdgeInsets.all(
                                                    10),
                                                margin:
                                                const EdgeInsets.all(
                                                    20),
                                                decoration: BoxDecoration(
                                                  color:
                                                  Colors.grey.shade300,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20),
                                                ),
                                                child: Text(
                                                  // "Tap to unblock and send messages",
                                                  tr(LocaleKeys
                                                      .tapToUnblockAndSendMessages),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                                :

                                            //first time message handler
                                            StreamBuilder<
                                                MessageRequestStatusModel>(
                                              stream: context
                                                  .read<
                                                  MessageRequestStatusRepository>()
                                                  .messageRequestStatusStream(
                                                  communicationModel!
                                                      .communicationId),
                                              builder: (context,
                                                  senderBlockedReceiverSnapshot) {
                                                if (senderBlockedReceiverSnapshot
                                                    .connectionState ==
                                                    ConnectionState
                                                        .waiting) {
                                                  return const ThemeSpinner(
                                                      size: 40);
                                                } else {
                                                  final messageStatusData =
                                                      senderBlockedReceiverSnapshot
                                                          .data;

                                                  final isReceiver =
                                                      messageStatusData
                                                          ?.requestSender ==
                                                          widget
                                                              .receiverUserId;

                                                  final isRequestPending =
                                                      messageStatusData
                                                          ?.status ==
                                                          MessageRequestStatus
                                                              .pending;

                                                  return (isReceiver &&
                                                      isRequestPending)
                                                      ?
                                                  //Manage message
                                                  StreamBuilder<
                                                      FirebaseUserProfileDetailsModel?>(
                                                    stream: FirebaseUserRepository()
                                                        .streamUserDetails(
                                                        userId: widget
                                                            .receiverUserId),
                                                    builder: (context,
                                                        firebaseUserSnapshot) {
                                                      final userDetails =
                                                          firebaseUserSnapshot
                                                              .data;

                                                      if (firebaseUserSnapshot
                                                          .connectionState ==
                                                          ConnectionState
                                                              .active &&
                                                          userDetails !=
                                                              null) {
                                                        return MessageRequestWidget(
                                                          receiverName:
                                                          userDetails
                                                              .name,
                                                          onAccept:
                                                              () {
                                                            //Update the message request status to rejected
                                                            updateMessageRequestStatus(
                                                                MessageRequestStatus
                                                                    .accepted);
                                                          },
                                                          onBlock:
                                                              () {
                                                            //Block the user
                                                            changeReceiverBlockStatus();

                                                            //Update the message request status to rejected
                                                            updateMessageRequestStatus(
                                                                MessageRequestStatus
                                                                    .rejected);
                                                          },
                                                          onReport:
                                                              () {
                                                            //Open the report screen
                                                            GoRouter.of(
                                                                context)
                                                                .pushNamed(
                                                              ReportScreen
                                                                  .routeName,
                                                              extra:
                                                              ChatReportPayload(
                                                                userId:
                                                                widget.receiverUserId,
                                                                reportCubit:
                                                                context.read<ReportCubit>(),
                                                              ),
                                                            );
                                                          },
                                                          onChatPrivacySettings:
                                                              () {
                                                            //Open the chat privacy settings
                                                            GoRouter.of(
                                                                context)
                                                                .pushNamed(
                                                                ProfilePrivacyScreen.routeName);
                                                          },
                                                        );
                                                      } else {
                                                        return const SizedBox
                                                            .shrink();
                                                      }
                                                    },
                                                  )
                                                      : StreamBuilder<
                                                      Map<
                                                          String,
                                                          List<
                                                              ConversationModel>>?>(
                                                      stream: context
                                                          .read<
                                                          ChatControllerCubit>()
                                                          .streamConversationMessages(
                                                        lastChatDeleteTime:
                                                        lastChatDeleteTime,
                                                        communicationId:
                                                        communicationModel!
                                                            .communicationId,
                                                        otherCommunicationPost:
                                                        widget
                                                            .otherCommunicationPost,
                                                      ),
                                                      builder: (context,
                                                          conversationSnapshot) {
                                                        if (conversationSnapshot
                                                            .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const ThemeSpinner(
                                                              size: 40);
                                                        } else {
                                                          final chatDateLogs =
                                                              conversationSnapshot
                                                                  .data;

                                                          bool
                                                          showTextField =
                                                          true;

                                                          /// Checks various conditions to determine the state of the chat:
                                                          ///
                                                          /// - `chatDateLogs != null`: Ensures that `chatDateLogs` is not null.
                                                          /// - `chatDateLogs.keys.isEmpty`: Checks if `chatDateLogs` has no keys.
                                                          /// - `chatDateLogs.keys.first.length >= 3`: Ensures the first key in `chatDateLogs` has a length of at least 3.
                                                          /// - `isRequestPending`: Checks if a request is pending.
                                                          /// - `!isReceiver`: Ensures that the current user is not the receiver.
                                                          if (chatDateLogs !=
                                                              null &&
                                                              chatDateLogs
                                                                  .keys
                                                                  .isNotEmpty &&
                                                              chatDateLogs
                                                                  .keys
                                                                  .first
                                                                  .length >=
                                                                  3 &&
                                                              isRequestPending &&
                                                              !isReceiver) {
                                                            showTextField =
                                                            false;
                                                          }
                                                          return !showTextField
                                                              ? const Center(
                                                            child:
                                                            Padding(
                                                              padding:
                                                              EdgeInsets.all(8.0),
                                                              child:
                                                              Text(
                                                                "Wait for the user to accept the message request",
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              :
                                                          //Send chat text box
                                                          BlocBuilder<
                                                              ChatControllerCubit,
                                                              ChatControllerState>(
                                                            builder:
                                                                (context, chatControllerState) {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 15),
                                                                child: SendMessageWidget(
                                                                  onTextMessageSend: (message) async {
                                                                    await setCommunicationVisibility(true).whenComplete(
                                                                          () async => await context.read<ChatControllerCubit>().sendMessage(
                                                                        communication: communicationModel!,
                                                                        message: message,
                                                                        messageType: MessageType.text,
                                                                        receiverUserId: widget.receiverUserId,
                                                                        receiverBlockedSender: receiverBlockedSender,
                                                                        otherCommunicationPost: widget.otherCommunicationPost,
                                                                      ),
                                                                    );
                                                                  },
                                                                  onMessageWithFileSend: (message, file, messageType) async {
                                                                    print("|||||||||||||||||||||||||||||||||||||||||||||||||");
                                                                    print(file.path);
                                                                    await setCommunicationVisibility(true).whenComplete(
                                                                          () async => await context.read<ChatControllerCubit>().sendMessage(
                                                                        communication: communicationModel!,
                                                                        message: message,
                                                                        messageType: messageType,
                                                                        file: file,
                                                                        receiverUserId: widget.receiverUserId,
                                                                        receiverBlockedSender: receiverBlockedSender,
                                                                        otherCommunicationPost: widget.otherCommunicationPost,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      });
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  //File upload loader
                                  Visibility(
                                    visible: dataUploadStatusState
                                            .dataUploadStatus ==
                                        DataUploadStatus.uploading,
                                    child: Container(
                                      color: Colors.black54,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const ThemeSpinner(),
                                          const SizedBox(height: 5),
                                          if (dataUploadStatusState.message !=
                                              null)
                                            Text(
                                              dataUploadStatusState.message!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
