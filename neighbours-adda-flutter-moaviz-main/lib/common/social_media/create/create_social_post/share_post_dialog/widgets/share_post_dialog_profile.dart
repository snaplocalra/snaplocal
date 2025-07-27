import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/address_with_location_icon_widget.dart';
import 'package:snap_local/utility/common/widgets/octagon_widget.dart';

class SharePostDialogProfileWidget extends StatelessWidget {
  final String image;
  final String name;
  final String? address;

  const SharePostDialogProfileWidget({
    super.key,
    required this.image,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OctagonWidget(
          shapeSize: 40,
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (address != null)
                AddressWithLocationIconWidget(
                  address: address!,
                  hideIcon: true,
                  fontSize: 11,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
