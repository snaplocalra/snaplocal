import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum PollsListType {
  onGoing(
    name: LocaleKeys.yoursVoiceMatters,
    description: LocaleKeys.participatePolls,
    api: "v2/polls/polls/ongoing",
  ),
  yourPolls(
    name: "Manage Your Polls",
    description: LocaleKeys.participatePolls,
    api: "v2/polls/my_polls/view",
  ),

  closedPolls(
    name: LocaleKeys.closedPolls,
    description: LocaleKeys.yourPollsDescription,
    api: "v2/polls/polls/closed",
  );

  final String name;
  final String description;
  final String api;
  const PollsListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
