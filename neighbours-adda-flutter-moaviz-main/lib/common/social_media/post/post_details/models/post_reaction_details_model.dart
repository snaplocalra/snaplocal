// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';

class PostReactionDetailsModel {
  int reactionCount;
  List<MostUsedEmojiModel> mostUsedEmojiList;
  PostReactionDetailsModel({
    required this.reactionCount,
    required this.mostUsedEmojiList,
  });

  static List<MostUsedEmojiModel> _userOwnReactionValidator({
    required List<MostUsedEmojiModel> publicReactions,
    required ReactionEmojiModel? ownReactionEmojiModel,
  }) {
    //Check that, is the user gave any reaction or not
    if (ownReactionEmojiModel != null) {
      //if the user gave any reaction and that is not present in the public reaction,
      //then add the user given reaction emoji to the public reaction list for view purpose
      if (!publicReactions
          .map((e) => e.imageUrl)
          .contains(ownReactionEmojiModel.imageUrl)) {
        publicReactions.add(MostUsedEmojiModel(
          id: ownReactionEmojiModel.id,
          imageUrl: ownReactionEmojiModel.imageUrl,
          isGivenByCurrentUser: true,
        ));
      }
    }
    return publicReactions;
  }

  factory PostReactionDetailsModel.fromMap({
    required Map<String, dynamic> map,
    required ReactionEmojiModel? ownReactionEmojiModel,
  }) {
    return PostReactionDetailsModel(
      reactionCount: (map['reaction_count'] ?? 0) as int,
      mostUsedEmojiList: _userOwnReactionValidator(
        publicReactions: List<MostUsedEmojiModel>.from(
            (map['most_used_emoji_list'])
                .map((e) => MostUsedEmojiModel.fromMap(e))).toList(),
        ownReactionEmojiModel: ownReactionEmojiModel,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reaction_count': reactionCount,
      'most_used_emoji_list': mostUsedEmojiList.map((e) => e.toMap()).toList(),
    };
  }
}

class MostUsedEmojiModel {
  final String id;
  final String imageUrl;
  final bool isGivenByCurrentUser;

  MostUsedEmojiModel({
    required this.id,
    required this.imageUrl,
    this.isGivenByCurrentUser = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': imageUrl,
      'is_given_by_current_user': isGivenByCurrentUser,
    };
  }

  factory MostUsedEmojiModel.fromMap(Map<String, dynamic> map) {
    return MostUsedEmojiModel(
      id: map['id'] as String,
      imageUrl: map['image'] as String,
      isGivenByCurrentUser: (map['is_given_by_current_user'] ?? false) as bool,
    );
  }
}
