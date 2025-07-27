import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/circular_svg_button_3d_widget.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_contacts_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class ChatIconWidget extends StatelessWidget {
  const ChatIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: FirebaseChatCommunicationRepository()
          .streamCurrentUserUnreadMessageCount(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        final moreThan99 = count > 9;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Badge(
            label: Text("${moreThan99 ? '9+' : count}"),
            backgroundColor: const Color(0xffe2037f),
            isLabelVisible: count > 0,
            offset: Offset(moreThan99 ? -5 : 0, -5),
            child: CircularSvgButton3D(
              height: 28,
              svgImage: SVGAssetsImages.homechat,
              onTap: () async {
                GoRouter.of(context).pushNamed(ChatContactsScreen.routeName);
              },
            ),
          ),
        );
      },
    );
  }
}
