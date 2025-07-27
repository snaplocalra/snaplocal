import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/social_media/post/master_post/model/social_post_model.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/widgets/post_view/post_view_widget.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/utility/constant/names.dart';

class SocialPostChatBubble extends StatelessWidget {
  final SocialPostModel socialPostModel;

  final double bubbleRadius;
  final bool isSender;
  final Color color;

  final String? timeStampText;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final TextStyle timeStampStyle;
  const SocialPostChatBubble({
    super.key,
    required this.socialPostModel,
    this.timeStampText,
    this.bubbleRadius = 14,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.timeStampStyle = const TextStyle(
      color: Color.fromRGBO(164, 169, 172, 1),
      fontSize: 12,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Container(
          constraints: BoxConstraints(maxWidth: mqSize.width * 0.6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bubbleRadius),
              topRight: Radius.circular(bubbleRadius),
              bottomLeft: Radius.circular(tail
                  ? isSender
                      ? bubbleRadius
                      : 0
                  : 16),
              bottomRight: Radius.circular(tail
                  ? isSender
                      ? 0
                      : bubbleRadius
                  : 16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: mqSize.height * 0.5,
                    maxWidth: mqSize.width * 0.7,
                  ),
                  margin: const EdgeInsets.all(4),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => PostDetailsControllerCubit(
                          socialPostModel: socialPostModel,
                        ),
                      ),
                      BlocProvider(
                        create: (context) => ShowReactionCubit(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            PostActionCubit(PostActionRepository()),
                      ),
                      BlocProvider(
                        create: (context) => ReportCubit(ReportRepository()),
                      ),
                      BlocProvider(
                        create: (context) => CommentViewControllerCubit(),
                      ),

                      //Hide post cubit
                      BlocProvider(
                        create: (context) =>
                            HidePostCubit(HidePostRepository()),
                      ),
                    ],
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: PostViewWidget(
                        key: ValueKey(socialPostModel.id),
                        isSharedView: true,
                        allowPostDetailsOpen: true,
                        openFromChat: true,
                        enableSpecialActivity: false,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Application name for social post chat bubble
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 2),
                    child: Text(
                      applicationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (timeStampText != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        6,
                        6,
                        stateTick ? 2 : 6,
                        6,
                      ),
                      child: Text(
                        timeStampText!,
                        style: timeStampStyle,
                      ),
                    ),
                  if (stateIcon != null && stateTick)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 6, 6, 6),
                      child: stateIcon,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
