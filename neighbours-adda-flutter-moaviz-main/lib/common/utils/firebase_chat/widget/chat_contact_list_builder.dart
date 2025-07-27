import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/filter_controller/filter_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_contact/chat_contact_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contact/chat_contact_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contacts_list_type.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_contact_widget.dart';
import 'package:snap_local/common/utils/widgets/shimmers/circle_card_shimmer.dart';
import 'package:snap_local/utility/common/search_box/logic/search/search_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ChatContactListBuilder extends StatelessWidget {
  final ChatContactsListType chatContactsListType;
  const ChatContactListBuilder({
    super.key,
    required this.chatContactsListType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterControllerCubit, FilterControllerState>(
      builder: (context, filterControllerState) {
        return BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchChatState) {
            return StreamBuilder<List<ChatContactModel>?>(
              stream: chatContactsListType == ChatContactsListType.users
                  ? context.read<ChatContactCubit>().streamUserChatContacts(
                        query: searchChatState.query,
                        filter: filterControllerState.filter,
                      )
                  : context.read<ChatContactCubit>().streamOtherChatContacts(
                        query: searchChatState.query,
                        filter: filterControllerState.filter,
                      ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleCardShimmerListBuilder(
                    padding: EdgeInsets.symmetric(vertical: 20),
                  );
                } else {
                  final snapShot = snapshot.data;
                  if (snapShot == null) {
                    return Center(child: Text(tr(LocaleKeys.dataError)));
                  } else {
                    final chatList = snapShot;

                    return (chatList.isEmpty)
                        ? Center(child: Text(tr(LocaleKeys.noChatFound)))
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const BouncingScrollPhysics(),
                            itemCount: chatList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final contact = chatList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ChatContactWidget(contact: contact),
                              );
                            },
                          );
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
