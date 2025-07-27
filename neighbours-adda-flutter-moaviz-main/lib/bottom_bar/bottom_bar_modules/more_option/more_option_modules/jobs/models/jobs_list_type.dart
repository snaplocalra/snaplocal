import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum JobsListType {
  byNeighbours(
    name: LocaleKeys.locallyJobs,
    description: LocaleKeys.findinglocaljobsiseasynow,
    api: "v3/jobs/jobs_by_neighbours",
  ),
  byYou(
    name: LocaleKeys.yourJobListings,
    description: LocaleKeys.findinglocaljobsiseasynow,
    api: "v3/jobs/jobs_by_me",
  );

  final String name;
  final String description;
  final String api;
  const JobsListType({
    required this.name,
    required this.description,
    required this.api,
  });
}
