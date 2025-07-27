import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/post/carousel_view/widget/carousel_view.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class CarouselViewScreen extends StatelessWidget {
  final List<NetworkMediaModel> mediaList;
  final int selectedMediaIndex;

  static String routeName = 'carousel-view';

  const CarouselViewScreen({
    super.key,
    required this.mediaList,
    required this.selectedMediaIndex,
  });

  @override
  Widget build(BuildContext context) {
    return NetworkMediaCarouselView(
      mediaList: mediaList,
      selectedMediaIndex: selectedMediaIndex,
    );
  }
}
