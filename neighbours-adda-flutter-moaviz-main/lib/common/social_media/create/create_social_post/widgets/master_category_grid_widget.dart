import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/social_media/create/create_social_post/model/master_category_model.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/tools/responsive.dart';

class MasterCategoryGridWidget extends StatelessWidget {
  final MasterCategoryModel masterCategory;
  const MasterCategoryGridWidget({super.key, required this.masterCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 0,
            // Offset controls the position of the shadow
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  masterCategory.svgPath,
                  height: 25,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  masterCategory.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        Responsive.deviceSize(context).width <= 390 ? 07 : 09,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: masterCategory.isSelected,
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: ApplicationColours.themePinkColor,
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
