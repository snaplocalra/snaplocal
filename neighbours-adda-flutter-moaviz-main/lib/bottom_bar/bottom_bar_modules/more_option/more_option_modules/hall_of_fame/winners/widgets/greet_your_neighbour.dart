import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class GreetYourNeighbours extends StatelessWidget {
  final String userId;
  final String userName;
  final void Function() onGreet;
  const GreetYourNeighbours({
    super.key,
    required this.userId,
    required this.userName,
    required this.onGreet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        onGreet.call();
        // GoRouter.of(context).pushNamed(ChatScreen.routeName,
        //     queryParameters: {"receiver_user_id": userId});
        await context.read<ChatControllerCubit>().sendExternalChatMessage(
          receiverUserId: userId,
          message: """
Hi $userName,
🎉 Congratulations on your impressive victory in the quiz! 🏆 Your knowledge and skills truly shine. Well done, and enjoy your well-deserved success!""",
        );
      },
      child: Stack(
        children: [
          Column(
            children: [
              SvgPicture.asset(SVGAssetsImages.cheers, height: 35),
              const SizedBox(height: 10),
              Text(
                tr(LocaleKeys.greetYourNeighbour),
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              SVGAssetsImages.greetShare,
              height: 12,
            ),
          ),
        ],
      ),
    );
  }
}
