import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../../utility/constant/assets_images.dart';

class MapV2GridDataWidget extends StatelessWidget {
  const MapV2GridDataWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.unseenPostCount,
    required this.onTap,
    required this.isVerified,
  });
  final String imageUrl;
  final String title;
  final String? subTitle;
  final int unseenPostCount;
  final bool isVerified;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              //data
              Positioned(
                bottom: 5,
                left: 5,
                child: SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: StrokeText(
                              text: title,
                              strokeWidth: 0.8,
                              overflow: TextOverflow.ellipsis,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          if(isVerified==true)...[
                            const SizedBox(width: 2),
                            SvgPicture.asset(
                              SVGAssetsImages.greenTick,
                              height: 12,
                              width: 12,
                            ),
                          ],
                        ],
                      ),
                      //sub title
                      if (subTitle != null)
                        StrokeText(
                          text: subTitle!,
                          strokeWidth: 0.8,
                          overflow: TextOverflow.ellipsis,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              //count of unseen posts
              if (unseenPostCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: unseenPostCount >= 100000 ? 12 : 10,
                    backgroundColor: ApplicationColours.themePinkColor,
                    child: Text(
                      unseenPostCount.formatNumber(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapV2GridDataWidget2 extends StatelessWidget {
  const MapV2GridDataWidget2({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.unseenPostCount,
    required this.onTap,
  });
  final String imageUrl;
  final String title;
  final String? subTitle;
  final int unseenPostCount;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),

              //data
              Positioned(
                bottom: 5,
                left: 5,
                child: SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      StrokeText(
                        text: title,
                        strokeWidth: 0.8,
                        overflow: TextOverflow.ellipsis,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),

                      //sub title
                      if (subTitle != null)
                        StrokeText(
                          text: subTitle!,
                          strokeWidth: 0.8,
                          overflow: TextOverflow.ellipsis,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              //count of unseen posts
              if (unseenPostCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: CircleAvatar(
                    radius: unseenPostCount >= 100000 ? 12 : 10,
                    backgroundColor: ApplicationColours.themePinkColor,
                    child: Text(
                      unseenPostCount.formatNumber(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
