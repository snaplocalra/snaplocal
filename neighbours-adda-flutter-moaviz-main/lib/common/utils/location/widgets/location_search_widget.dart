import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
    required this.title,
  });

  final String location;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(SVGAssetsImages.getLocate, height: 20, width: 20),
            const SizedBox(width: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xff4d4d4d),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          location,
          style: const TextStyle(
            color: Color(0xff969696),
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
