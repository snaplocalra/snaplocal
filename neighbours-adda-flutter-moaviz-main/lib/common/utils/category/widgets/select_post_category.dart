import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/category_widget.dart';
import 'package:snap_local/common/social_media/create/create_social_post/widgets/shimmers/category_shimmer.dart';
import 'package:snap_local/common/utils/category/v1/model/category_model.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class SelectPostCategory extends StatelessWidget {
  final CategoryListModel categoryListModel;
  final bool dataLoading;
  final void Function(String id) onSelectCategory;
  const SelectPostCategory({
    super.key,
    required this.categoryListModel,
    required this.onSelectCategory,
    this.dataLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final logs = categoryListModel.data;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.selectCategory),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: ApplicationColours.themeBlueColor,
            ),
          ),
          const SizedBox(height: 4),
          dataLoading
              ? const CategoryShimmer()
              : logs.isEmpty
                  ? const ErrorTextWidget(error: "No category found")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              onSelectCategory.call(logs[index].id);
                            },
                            child: CategoryWidget(
                              name: logs[index].name,
                              imageUrl: logs[index].imageUrl,
                              isSelected: logs[index].isSelected,
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
