import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/circular_tick.dart';

class CategoryWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isSelected;
  const CategoryWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? const Color.fromRGBO(173, 175, 187, 0.41)
            : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageUrl != null)
                  CachedNetworkImage(
                    cacheKey: imageUrl!,
                    imageUrl: imageUrl!,
                    height: 25,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircularTick(
            showTick: isSelected,
            tickSize: 20,
          ),
        ],
      ),
    );
  }
}
