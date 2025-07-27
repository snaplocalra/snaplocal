import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/master_category_grid_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/master_category_list.dart';
import 'package:snap_local/utility/tools/responsive.dart';

class MasterCategorySelectorWidget extends StatelessWidget {
  const MasterCategorySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = MasterCategoryList(context).categories;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              tr(LocaleKeys.selectCategory),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: Responsive.isDesktop(context)
                ? 8
                : Responsive.isTablet(context)
                    ? 6
                    : 4,
            childAspectRatio: 1.2,
          ),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final masterCategory = logs[index];
            return GestureDetector(
              onTap: () {
                masterCategory.onTap();
              },
              child: MasterCategoryGridWidget(masterCategory: masterCategory),
            );
          },
        ),
      ],
    );
  }
}
