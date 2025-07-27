import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum MessageType {
  post(param: "post", displayName: LocaleKeys.post),
  text(param: "text", displayName: "Text"),
  image(param: "image", displayName: "Photo"),
  video(param: "video", displayName: "Video"),
  audio(param: "audio", displayName: "Audio"),
  pdf(param: "pdf", displayName: "Document");

  final String param;
  final String displayName;
  const MessageType({required this.param, required this.displayName});

  factory MessageType.setMessageType(String data) {
    switch (data) {
      case "video":
        return video;
      case "audio":
        return audio;
      case "image":
        return image;
      case "pdf":
        return pdf;
      case "post":
        return post;
      default:
        return text;
    }
  }
}
