import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum PostType {
  all(
    param: "all",
    displayText: (LocaleKeys.all),
    captionText: "",
    svgPath: SVGAssetsImages.general,
  ),
  general(
    param: "general",
    displayText: (LocaleKeys.general),
    captionText: "What's Happening, neighbour?",
    svgPath: SVGAssetsImages.general,
  ),
  lostFound(
    param: "lost_and_found",
    captionText: LocaleKeys.lostFoundDescription,
    displayText: LocaleKeys.lostAndFound,
    svgPath: SVGAssetsImages.lostFound,
  ),
  safety(
    param: "safety_and_alerts",
    captionText: LocaleKeys.describeIncident,
    displayText: LocaleKeys.safetyAndAlerts,
    svgPath: SVGAssetsImages.safety,
  ),
  event(
    param: "event",
    captionText: LocaleKeys.eventDescription,
    displayText: LocaleKeys.event,
    svgPath: SVGAssetsImages.event,
  ),
  poll(
    param: "poll",
    captionText: LocaleKeys.askPollQuestion,
    displayText: LocaleKeys.poll,
    svgPath: SVGAssetsImages.polls,
  ),
  askQuestion(
    param: "ask_question",
    displayText: LocaleKeys.question,
    captionText: LocaleKeys.askYourQuestion,
    svgPath: SVGAssetsImages.askQuestion,
  ),
  askSuggestion(
    param: "ask_suggestion",
    displayText: LocaleKeys.suggestion,
    captionText: LocaleKeys.askForSuggestion,
    svgPath: SVGAssetsImages.askRecommendation,
  ),
  //news
  newsPost(
    param: "news",
    captionText: LocaleKeys.news,
    displayText: LocaleKeys.news,
    svgPath: SVGAssetsImages.localNews,
  ),
  //Shared Post
  sharedPost(
    param: "shared_post",
    displayText: LocaleKeys.sharedPost,
    captionText: LocaleKeys.shareYourThoughts,
    svgPath: SVGAssetsImages.shareArrow,
  );
  // officialPost(
  // param: "official",
  // captionText: LocaleKeys.general,
  // displayText: LocaleKeys.general,
  // svgPath: SVGAssetsImages.general,
  // );

  final String param;
  final String displayText;
  final String captionText;
  final String svgPath;

  const PostType({
    required this.param,
    required this.displayText,
    required this.captionText,
    required this.svgPath,
  });

  factory PostType.fromString(String param) {

    switch (param) {
      case 'general':
      case 'official':
        return PostType.general;
        //return PostType.officialPost;
      case 'lost_and_found':
        return PostType.lostFound;
      case 'safety_and_alerts':
        return PostType.safety;
      case 'event':
        return PostType.event;
      case 'poll':
        return PostType.poll;
      case 'news':
        return PostType.newsPost;
      case 'ask_question':
        return PostType.askQuestion;
      case 'ask_suggestion':
        return PostType.askSuggestion;
      case 'shared_post':
        return PostType.sharedPost;
      default:
        throw Exception("Unknown post type: $param");
    }
  }
}
