// ignore_for_file: use_build_context_synchronously

import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/helper/scam_dialog_shared_preference/scam_dialog_shared_preference.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/widget/aware_scam_dialog.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class SendMessageToNeighbours extends StatefulWidget {
  final String receiverUserId;
  final OtherCommunicationPost otherCommunicationModelImpl;
  final ScamType scamType;
  final String? heading;

  const SendMessageToNeighbours({
    super.key,
    required this.receiverUserId,
    required this.scamType,
    required this.otherCommunicationModelImpl,
    this.heading,
  });

  @override
  State<SendMessageToNeighbours> createState() =>
      _SendMessageToNeighboursState();
}

class _SendMessageToNeighboursState extends State<SendMessageToNeighbours> {
  final chatMessageTextController = TextEditingController();
  final scamDialogTokenSharedPref = ScamDialogTokenSharedPref();

  @override
  void dispose() {
    super.dispose();
    chatMessageTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.heading ?? "Send Message",
          style: TextStyle(
            color: ApplicationColours.themeBlueColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        BlocProvider(
          create: (context) => ChatControllerCubit(
            dataUploadStatusCubit: DataUploadStatusCubit(),
            firebaseChatRepository: context.read<FirebaseChatRepository>(),
          ),
          child: BlocConsumer<ChatControllerCubit, ChatControllerState>(
            listener: (context, chatControllerState) {
              if (chatControllerState.isSendMessageRequestSuccess) {
                //After sending the message, open the chat screen
                //Navigate to chat screen
                GoRouter.of(context).pushNamed(
                  ChatScreen.routeName,
                  queryParameters: {
                    "receiver_user_id": widget.receiverUserId,
                  },
                  //Other communication model is used to create chat for sales post and job
                  extra: widget.otherCommunicationModelImpl,
                );
              }
            },
            builder: (context, chatControllerState) {
              return StatefulBuilder(builder: (context, chatTextState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ThemeTextFormField(
                          enabled: !chatControllerState.messageSendLoading,
                          controller: chatMessageTextController,
                          hint: tr(LocaleKeys.typeyourmessage),
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 2,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          hintStyle: const TextStyle(fontSize: 12),
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.0,
                          ),
                          onChanged: (_) {
                            chatTextState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: ThemeElevatedButton(
                          textFontSize: 12,
                          padding: EdgeInsets.zero,
                          height: mqSize.height * 0.05,
                          buttonName: tr(LocaleKeys.send),
                          showLoadingSpinner:
                              chatControllerState.messageSendLoading,
                          disableButton:
                              chatMessageTextController.text.trim().isEmpty,
                          onPressed: () async {
                            if (chatMessageTextController.text
                                .trim()
                                .isNotEmpty) {
                              //Close the keyboard
                              FocusManager.instance.primaryFocus?.unfocus();

                              //As per the scam types, check the scamDialogTokenSharedPref
                              final isScamDialogViewed =
                                  widget.scamType == ScamType.job
                                      ? await scamDialogTokenSharedPref
                                          .getJobScamDialogViewStatus()
                                      : widget.scamType == ScamType.business
                                          ? await scamDialogTokenSharedPref
                                              .getBusinessScamDialogViewStatus()
                                          : await scamDialogTokenSharedPref
                                              .getBuySellScamDialogViewStatus();

                              if (!isScamDialogViewed) {
                                //Show scam dialog
                                await showScamDialog(context,
                                        scamType: widget.scamType)
                                    .whenComplete(() async {
                                  //As per the scam types, set the scamDialogTokenSharedPref
                                  widget.scamType == ScamType.job
                                      ? await scamDialogTokenSharedPref
                                          .makeJobScamDialogViewed()
                                      : widget.scamType == ScamType.business
                                          ? await scamDialogTokenSharedPref
                                              .makeBusinessScamDialogViewed()
                                          : await scamDialogTokenSharedPref
                                              .makeBuySellScamDialogViewed();
                                });
                              }

                              //Send message to the receiver user
                              await context
                                  .read<ChatControllerCubit>()
                                  .sendExternalChatMessage(
                                    showSuccessToast: false,
                                    receiverUserId: widget.receiverUserId,
                                    message:
                                        chatMessageTextController.text.trim(),
                                    otherCommunicationPost:
                                        widget.otherCommunicationModelImpl,
                                  )
                                  .whenComplete(
                                    () => chatMessageTextController.clear(),
                                  );
                            }
                            chatTextState(() {});
                          },
                          backgroundColor:
                              chatMessageTextController.text.trim().isEmpty
                                  ? Colors.grey.shade300
                                  : ApplicationColours.themeBlueColor,
                        ),
                      )
                    ],
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
