import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ProfileConnectionType {
  myConnections(
    name: LocaleKeys.myConnections,
    type: "accepted",
    api: "user_connections",
  ),
  requests(
    name: LocaleKeys.requests,
    type: "pending",
    api: "user_connections/requested_list",
  );

  final String name;
  final String type;
  final String api;
  const ProfileConnectionType({
    required this.name,
    required this.type,
    required this.api,
  });
}
