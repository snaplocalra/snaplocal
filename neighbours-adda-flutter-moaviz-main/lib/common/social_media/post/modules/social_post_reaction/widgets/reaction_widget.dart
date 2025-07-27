import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/emoji_static_data.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';

class ReactionWidget extends StatelessWidget {
  final String postId;
  final void Function(ReactionEmojiModel reactionEmojiModel) onReact;
  const ReactionWidget({
    super.key,
    required this.postId,
    required this.onReact,
  });

  @override
  Widget build(BuildContext context) {
    final reactionEmojiListModel = ReactionEmojiList.fromMap(emojiData);
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              // changes position of shadow
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: reactionEmojiListModel.reactionEmojiList.map((reaction) {
            return GestureDetector(
              onTap: () => onReact.call(reaction),
              child: SvgPicture.network(
                reaction.imageUrl,
                height: 30,
                width: 30,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
