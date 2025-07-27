import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';

class GroupPostProfilePictureWidget extends StatelessWidget {
  const GroupPostProfilePictureWidget({
    super.key,
    required this.groupImageUrl,
    required this.userImageUrl,
    this.onUserImageTap,
    this.onGroupImageTap,
  });
  final String groupImageUrl;
  final String userImageUrl;

  final void Function()? onUserImageTap;
  final void Function()? onGroupImageTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          GestureDetector(
            onTap: onGroupImageTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                cacheKey: groupImageUrl,
                imageUrl: groupImageUrl,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: 0,
            child: GestureDetector(
              //Profile navigation
              onTap: onUserImageTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                child: NetworkImageCircleAvatar(
                  imageurl: userImageUrl,
                  radius: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
