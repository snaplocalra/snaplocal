//Reaction update
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_reaction_details_model.dart';
import 'package:snap_local/common/social_media/post/post_details/models/post_state_update/post_state_update.dart';

class UpdateReactionState implements PostStateUpdate {
  final ReactionEmojiModel? reactionEmojiModel;
  final bool isFirstReaction;

  UpdateReactionState(
    this.reactionEmojiModel,
    this.isFirstReaction,
  );

  @override
  void updateState(SocialPostModel socialPostModel) {
    if (socialPostModel.postReactionDetailsModel != null) {
      final mostUsedEmojiList =
          socialPostModel.postReactionDetailsModel!.mostUsedEmojiList;

      //Check whether the user selected some reaction or not
      if (reactionEmojiModel != null) {
        //If the user add the reaction for the 1st time, then increase the counter
        if (isFirstReaction) {
          socialPostModel.postReactionDetailsModel!.reactionCount++;
        } else {
          //if the user updating the reaction 1st remove the previous user given reaction
          mostUsedEmojiList
              .removeWhere((element) => element.isGivenByCurrentUser);
        }

        //Before adding the reaction in the list, 1st check whether the current user
        //given reaction id is available in the most used emoji list or not
        final isSameReactionAvailable = socialPostModel
            .postReactionDetailsModel!.mostUsedEmojiList
            .map((e) => e.id)
            .contains(reactionEmojiModel!.id);

        if (!isSameReactionAvailable) {
          mostUsedEmojiList.add(MostUsedEmojiModel(
            id: reactionEmojiModel!.id,
            imageUrl: reactionEmojiModel!.imageUrl,
            isGivenByCurrentUser: true,
          ));
        }
      } else {
        //Decrease the reaction counter value
        socialPostModel.postReactionDetailsModel!.reactionCount--;
        if (socialPostModel.postReactionDetailsModel!.reactionCount == 0) {
          //After decreasing the reaction counter, if it will 0, then make the Reaction Details null
          socialPostModel.postReactionDetailsModel = null;
        } else {
          //If the reaction counter is not 0, then remove the user given reaction
          mostUsedEmojiList
              .removeWhere((element) => element.isGivenByCurrentUser);
        }
      }
    } else {
      //If there is no reaction available on the post, then add the 1st reaction
      if (reactionEmojiModel != null) {
        socialPostModel.postReactionDetailsModel = PostReactionDetailsModel(
          reactionCount: 1,
          mostUsedEmojiList: [
            MostUsedEmojiModel(
              id: reactionEmojiModel!.id,
              imageUrl: reactionEmojiModel!.imageUrl,
              isGivenByCurrentUser: true,
            )
          ],
        );
      }
    }

    //update the reaction emoji model
    socialPostModel.reactionEmojiModel = reactionEmojiModel;
  }
}
