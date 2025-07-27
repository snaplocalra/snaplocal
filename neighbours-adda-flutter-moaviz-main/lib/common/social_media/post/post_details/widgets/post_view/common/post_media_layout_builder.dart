import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/media_handing_widget/media_widget.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class PostMediaLayoutBuilder extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;

  const PostMediaLayoutBuilder({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    final mediaLength = mediaList.length;
    if (mediaLength > 1) {
      return SizedBox(
        height: 200,
        width: mqSize.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: mediaLength == 2
                  ? TwoImageLayout(mediaList: mediaList)
                  : mediaLength == 3
                      ? ThreeImageLayout(mediaList: mediaList)
                      : mediaLength == 4
                          ? FourImageLayout(mediaList: mediaList)
                          : FiveImageLayout(mediaList: mediaList),
            )),
      );
    } else {
      return SingleMedia(media: mediaList[0]);
    }
  }
}

class SingleMedia extends StatelessWidget {
  final NetworkMediaModel media;

  const SingleMedia({
    super.key,
    required this.media,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    // return Text('Hello Single Media ${media.mediaUrl}');
    // return SizedBox(
    //   width: mqSize.width,
    //   child: NetworkMediaWidget(
    //     key: ValueKey(media.mediaUrl),
    //     media: media,
    //     fit: BoxFit.cover,
    //     // height: 500,
    //     videoheight: 300,
    //   ),
    // );

    return SizedBox(
      width: mqSize.width,
      child: NetworkMediaWidgetV2(
        key: ValueKey(media.mediaUrl),
        media: media,
        fit: BoxFit.cover,
        // height: 500,
        videoheight: 300,
      ),
    );
  }
}

// Hari did
class TwoImageLayout extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;

  const TwoImageLayout({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: NetworkMediaWidget(
                key: ValueKey(mediaList[0].mediaUrl),
                media: mediaList[0],
                width: mqSize.width,
                fit: BoxFit.cover,
                videoheight: 200,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: NetworkMediaWidget(
                key: ValueKey(mediaList[1].mediaUrl),
                media: mediaList[1],
                fit: BoxFit.cover,
                width: mqSize.width,
                videoheight: 200,
              ),
            )
          ],
        );
      },
    );
  }
}

class ThreeImageLayout extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;

  const ThreeImageLayout({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkMediaWidget(
                  key: ValueKey(mediaList[0].mediaUrl),
                  media: mediaList[0],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  videoheight: 200,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[1].mediaUrl),
                        media: mediaList[1],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[2].mediaUrl),
                        media: mediaList[2],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FourImageLayout extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;

  const FourImageLayout({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[0].mediaUrl),
                        media: mediaList[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[1].mediaUrl),
                        media: mediaList[1],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[2].mediaUrl),
                        media: mediaList[2],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[3].mediaUrl),
                        media: mediaList[3],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FiveImageLayout extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;

  const FiveImageLayout({super.key, required this.mediaList});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[0].mediaUrl),
                        media: mediaList[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[1].mediaUrl),
                        media: mediaList[1],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[2].mediaUrl),
                        media: mediaList[2],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: NetworkMediaWidget(
                        key: ValueKey(mediaList[3].mediaUrl),
                        media: mediaList[3],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        videoheight: 200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          NetworkMediaWidget(
                            key: ValueKey(mediaList[4].mediaUrl),
                            media: mediaList[4],
                            fit: BoxFit.cover,
                            height: double.infinity,
                            videoheight: 200,
                          ),
                          Visibility(
                            visible: mediaList.length != 5,
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(0.4),
                              child: Text(
                                "+${mediaList.length - 5}",
                                style: const TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
