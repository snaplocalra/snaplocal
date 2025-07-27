import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/models/winners_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/winners/widgets/greet_your_neighbour.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_controller/chat_controller_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';

class WinnersShortDetailsWidget extends StatefulWidget {
  final WinnerDetailsModel winnerDetailsModel;
  const WinnersShortDetailsWidget({
    super.key,
    required this.winnerDetailsModel,
  });

  @override
  State<WinnersShortDetailsWidget> createState() =>
      _WinnersShortDetailsWidgetState();
}

class _WinnersShortDetailsWidgetState extends State<WinnersShortDetailsWidget> {
  late final ConfettiController _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 5));

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          NetworkImageCircleAvatar(
            radius: 30,
            imageurl: widget.winnerDetailsModel.image,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.winnerDetailsModel.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AddressWithLocationIconWidget(
                  address: widget.winnerDetailsModel.address,
                  fontSize: 12,
                  iconSize: 12,
                ),
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.winnerDetailsModel.topics.length,
                    itemBuilder: (context, index) {
                      final topicDetails =
                          widget.winnerDetailsModel.topics[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: CachedNetworkImage(
                                cacheKey: topicDetails.imageUrl!,
                                imageUrl: topicDetails.imageUrl!,
                                fit: BoxFit.scaleDown,
                                height: 10,
                              ),
                            ),
                            Text(
                              topicDetails.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: !widget.winnerDetailsModel.isOwner,
            child: BlocProvider(
              create: (context) => ChatControllerCubit(
                dataUploadStatusCubit: DataUploadStatusCubit(),
                firebaseChatRepository: context.read<FirebaseChatRepository>(),
              ),
              child: Builder(builder: (context) {
                return BlocListener<ChatControllerCubit, ChatControllerState>(
                  listener: (context, chatControllerState) {
                    if (chatControllerState.isSendMessageRequestSuccess) {
                      //After greetings stop the animation
                      _controllerCenter.stop();
                    }
                  },
                  child: Stack(
                    children: [
                      GreetYourNeighbours(
                        userId: widget.winnerDetailsModel.id,
                        userName: widget.winnerDetailsModel.name,
                        onGreet: () {
                          //greetings animation start
                          _controllerCenter.play();
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ConfettiWidget(
                          confettiController: _controllerCenter,
                          blastDirectionality: BlastDirectionality
                              .explosive, // don't specify a direction, blast randomly
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
