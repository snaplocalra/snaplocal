import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class NetworkPostMediaViewer extends StatelessWidget {
  const NetworkPostMediaViewer({
    super.key,
    required this.imageUrlList,
  });

  final List<String> imageUrlList;

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Visibility(
        visible: imageUrlList.isNotEmpty,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: mqSize.height * 0.15,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: imageUrlList.length,
            itemBuilder: (context, index) {
              final imageUrl = imageUrlList[index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    showImageViewer(
                      context,
                      CachedNetworkImageProvider(imageUrl),
                      swipeDismissible: true,
                      doubleTapZoomable: true,
                      backgroundColor: Colors.black,
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      cacheKey: imageUrl,
                      imageUrl: imageUrl,
                      height: mqSize.height * 0.16,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
