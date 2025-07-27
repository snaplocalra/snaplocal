import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ChatContactsListType {
  users(
    name: LocaleKeys.neighbours,
    description: LocaleKeys.neighboursChatDescription,
  ),
  other(
    name: LocaleKeys.others,
    description: LocaleKeys.othersChatDescription,
  ),
  localChat(
    //name: LocaleKeys.localChats,
    name: "Chill Chat",
    description: LocaleKeys.localChatsDescription,
  );

  final String name;
  final String description;

  const ChatContactsListType({required this.name, required this.description});
}
