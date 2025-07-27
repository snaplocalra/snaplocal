import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum ReportType {
  //General report types
  market(
    jsonName: "market",
    title: LocaleKeys.buyAndsell,
    reportQuestion: "Why do you want to report this local businesses?",
  ),
  neighboursProfile(
    jsonName: "neighbours_profile",
    title: LocaleKeys.neighbours,
    reportQuestion: "Why do you want to report this individual neighbour?",
  ),
  page(
    jsonName: "page",
    title: LocaleKeys.pages,
    reportQuestion: "Why do you want to report this page?",
  ),
  group(
    jsonName: "group",
    title: LocaleKeys.groups,
    reportQuestion: "Why do you want to report this group?",
  ),
  offerCoupon(
    jsonName: "offer_coupon",
    title: LocaleKeys.offersAndCoupons,
    reportQuestion: "Why do you want to report this coupon?",
  ),
  job(
    jsonName: "job",
    title: LocaleKeys.jobs,
    reportQuestion: LocaleKeys.whyDoYouWantToReportThisJob,
  ),

  business(
    jsonName: "business",
    title: LocaleKeys.business,
    reportQuestion: LocaleKeys.whyDoYouWantToReportThisBusiness,
  ),
  chat(
    jsonName: "chat",
    title: LocaleKeys.chat,
    reportQuestion: "Why do you want to report this chat?",
  ),

  //Comment
  comment(
    jsonName: "comment",
    title: LocaleKeys.comments,
    reportQuestion: "Why do you want to report this comment?",
  ),

  //Social media post types
  event(
    jsonName: "event",
    title: LocaleKeys.event,
    reportQuestion: LocaleKeys.whyDoYouWantToReportThisEvent,
  ),
  poll(
    jsonName: "poll",
    title: LocaleKeys.polls,
    reportQuestion: "Why do you want to report this poll?",
  ),
  regularPost(
    jsonName: "regular_post",
    title: LocaleKeys.posts,
    reportQuestion: "Why do you want to report this post?",
  );

  final String jsonName;
  final String title;
  final String reportQuestion;
  const ReportType({
    required this.jsonName,
    required this.title,
    required this.reportQuestion,
  });
}
