import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/screen/business_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/screens/business_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_offers/local_offers_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_offers/local_offers_state.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/common/see_all_button.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class OffersNearYouSection extends StatefulWidget {
  const OffersNearYouSection({super.key});

  @override
  State<OffersNearYouSection> createState() => _OffersNearYouSectionState();
}

class _OffersNearYouSectionState extends State<OffersNearYouSection> {
  @override
  void initState() {
    super.initState();
    // Fetch local offers when widget initializes
    context.read<LocalOffersCubit>().fetchLocalOffers();
  }

  Widget _buildShimmerItem() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer with discount badge
          Stack(
            children: [
              ShimmerWidget(
                width: double.infinity,
                height: 120,
                shapeBorder: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: ShimmerWidget(
                  width: 60,
                  height: 20,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          // Business details shimmer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: 120,
                  height: 14,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerWidget(
                      width: 14,
                      height: 14,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: ShimmerWidget(
                        width: double.infinity,
                        height: 12,
                        shapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ShimmerWidget(
                      width: 14,
                      height: 14,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ShimmerWidget(
                      width: 40,
                      height: 12,
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalOffersCubit, LocalOffersState>(
      builder: (context, state) {
        // Return empty widget if loading, has error, or no offers
        if (state.dataLoading || state.error != null || state.offers.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Local Offers Near You',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  SeeAllButton(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                        BusinessScreen.routeName,
                        extra: BusinessViewType.offers,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  final offer = state.offers[index];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(
                          BusinessDetailsScreen.routeName,
                          queryParameters: {'id': offer.id.toString()});
                    },
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  offer.postType == 'coupon'
                                      ? offer.couponImage ??
                                          'assets/local_images/offers.png'
                                      : offer.media.isNotEmpty
                                          ? offer.media.first.mediaPath
                                          : 'assets/local_images/offers.png',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '50% OFF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  offer.postType == 'coupon'
                                      ? 'Special Coupon'
                                      : offer.businessName ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        offer.businessAddress ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.directions_walk_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDistance(offer.distance),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDistance(String? distance) {
    if (distance == null) return '0m';

    final distanceValue =
        double.tryParse(distance.replaceAll('km', '').trim()) ?? 0.0;

    final roundedDistance = double.parse(distanceValue.toStringAsFixed(2));

    if (roundedDistance < 1) {
      final meters = (roundedDistance * 1000).round();
      return '${meters}m';
    }

    return '${roundedDistance}km';
  }
}
