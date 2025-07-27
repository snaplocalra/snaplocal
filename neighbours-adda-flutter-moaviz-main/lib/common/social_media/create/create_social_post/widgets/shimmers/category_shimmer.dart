import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              ShimmerWidget(
                height: 30,
                width: 30,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ShimmerWidget(
                height: 15,
                width: 200,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
