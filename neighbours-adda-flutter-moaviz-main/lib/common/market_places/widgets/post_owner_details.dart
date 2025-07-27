import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/review_module/model/ratings_model.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/screen/review_ratings_details.dart';
import 'package:snap_local/common/utils/helper/profile_navigator.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/common/utils/widgets/image_circle_avatar.dart';
import 'package:snap_local/utility/extension_functions/number_formatter.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

import '../../../utility/constant/assets_images.dart';

class PostOwnerDetails extends StatefulWidget {
  const PostOwnerDetails({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.isVerified,
    this.isOwner,
    this.category,
    this.ratingsModel,
    this.postCreatedAt,
    this.onProfileTap,
    this.ratingType,
    this.ratingTypeId,
  });

  final String id;
  final String name;
  final String image;
  final String address;
  final bool isVerified;
  final bool? isOwner;
  final String? category;
  final RatingsModel? ratingsModel;
  final DateTime? postCreatedAt;
  final void Function()? onProfileTap;
  final String? ratingTypeId;
  final RatingType? ratingType;

  @override
  State<PostOwnerDetails> createState() => _PostOwnerDetailsState();
}

class _PostOwnerDetailsState extends State<PostOwnerDetails> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onProfileTap ??
              () {
                if (widget.isOwner != null) {
                  //Profile navigation
                  userProfileNavigation(
                    context,
                    userId: widget.id,
                    isOwner: widget.isOwner!,
                  );
                }
              },
          child: NetworkImageCircleAvatar(
            imageurl: widget.image,
            radius: 20,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 2, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onProfileTap ??
                              () {
                            if (widget.isOwner != null) {
                              //Profile navigation
                              userProfileNavigation(
                                context,
                                userId: widget.id,
                                isOwner: widget.isOwner!,
                              );
                            }
                          },
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if(widget.isVerified==true)...[
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        SVGAssetsImages.greenTick,
                        height: 12,
                        width: 12,
                      ),
                    ],
                  ],
                ),
                Visibility(
                  visible: widget.address.isNotEmpty,
                  child: AddressWithLocationIconWidget(
                    address: widget.address,
                    fontSize: 10,
                    iconTopPadding: 1,
                  ),
                ),
                if (widget.postCreatedAt != null)
                  Text(
                    FormatDate.ddMMampm(widget.postCreatedAt!),
                    style: const TextStyle(
                      color: Color.fromRGBO(113, 108, 108, 1),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (widget.category != null)
                  Text(
                    widget.category!,
                    style: const TextStyle(
                      color: Color.fromRGBO(113, 108, 108, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                if (widget.ratingsModel != null)
                  GestureDetector(
                    onTap: (widget.ratingType == null &&
                            widget.ratingTypeId == null)
                        ? null
                        : () {
                            GoRouter.of(context).pushNamed(
                              RatingsReviewDetailsScreen.routeName,
                              queryParameters: {'id': widget.ratingTypeId},
                              extra: widget.ratingType,
                            );
                          },
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          RatingStars(
                            value: widget.ratingsModel!.starRating,
                            valueLabelVisibility: false,
                            starCount: 5,
                            starSize: 12,
                            maxValue: 5,
                            starSpacing: 4,
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: const Color.fromRGBO(243, 141, 24, 1),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(${widget.ratingsModel!.totalReview.formatNumber()})",
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
