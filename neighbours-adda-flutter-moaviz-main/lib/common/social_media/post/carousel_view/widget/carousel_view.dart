// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:snap_local/common/social_media/post/carousel_view/media_counter/media_counter_cubit.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/media_player/video/video_thumbnail_holder.dart';

class NetworkMediaCarouselView extends StatefulWidget {
  final List<NetworkMediaModel> mediaList;
  final int selectedMediaIndex;
  const NetworkMediaCarouselView({
    super.key,
    required this.mediaList,
    required this.selectedMediaIndex,
  });

  @override
  State<NetworkMediaCarouselView> createState() =>
      _NetworkMediaCarouselViewState();
}

class _NetworkMediaCarouselViewState extends State<NetworkMediaCarouselView> {
  final mediaCounterCubit = MediaCounterCubit(curentMediaIndex: 1);
  
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: null, // Reset to default status bar color
    ));
    super.dispose();
  }

  @override
  void initState() {
    super.initState();    
    mediaCounterCubit.changeMediaIndex(widget.selectedMediaIndex + 1);
      }

  @override
  Widget build(BuildContext context) {
    final mediaLength = widget.mediaList.length;
    print('Media Lenght: ${mediaLength}');

    return BlocProvider.value(
      value: mediaCounterCubit,
      child: Scaffold(
        backgroundColor: Colors.black87,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Visibility(
            visible: mediaLength > 1,
            child: BlocBuilder<MediaCounterCubit, MediaCounterState>(
              builder: (context, mediaCounterState) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "${mediaCounterState.curentMediaIndex} of $mediaLength",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FlutterCarousel.builder(
                itemCount: mediaLength,                
                options: FlutterCarouselOptions(
                  enableInfiniteScroll: false,
                  height: double.infinity,
                  viewportFraction: 1.0,
                  showIndicator: false,
                  initialPage: widget.selectedMediaIndex,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    context
                        .read<MediaCounterCubit>()
                        .changeMediaIndex(index + 1);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final serverMedia = widget.mediaList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: serverMedia is NetworkVideoMediaModel
                        ? VideoThumbnailHolder(networkVideo: serverMedia)
                        : serverMedia is NetworkImageMediaModel
                            ? EasyImageView(
                                doubleTapZoomable: true,
                                imageProvider: CachedNetworkImageProvider(
                                  serverMedia.imageUrl,
                                ),
                              )
                            : throw ("Unsupported media type"),
                  );
                }),
          );
        }),
      ),
    );
  }
}
