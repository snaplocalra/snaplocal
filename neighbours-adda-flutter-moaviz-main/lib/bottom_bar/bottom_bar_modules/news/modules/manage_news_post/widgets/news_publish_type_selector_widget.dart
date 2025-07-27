import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/news_post_type_controller/news_post_type_controller_cubit.dart';
import 'package:snap_local/utility/common/widgets/widget_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsPostTypeSelectorWidget extends StatelessWidget {
  const NewsPostTypeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetHeading(
          title: tr(LocaleKeys.newsPostType),
        ),
        const SizedBox(height: 5),
        BlocBuilder<NewsPostTypeControllerCubit, NewsPostTypeControllerState>(
          builder: (context, newsPostTypeControllerState) {
            final newsPostTypeList =
                newsPostTypeControllerState.newsPostTypeList;
            return Row(
              children: List.generate(
                newsPostTypeList.length,
                (index) {
                  final newsPostType = newsPostTypeList[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<NewsPostTypeControllerCubit>()
                            .selectNewsPostType(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: newsPostType.isSelected
                              ? ApplicationColours.themeBlueColor
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: FittedBox(
                          child: Text(
                            tr(newsPostType.newsPostType.displayText),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
