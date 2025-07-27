import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/utility/common/widgets/circular_tick.dart';

class NewsLanguageChangePopUp extends StatelessWidget {
  const NewsLanguageChangePopUp({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsLanguageChangeControllerCubit,
        NewsLanguageChangeControllerState>(
      builder: (context, newsLanguageChangeControllerState) {
        final languages =
            newsLanguageChangeControllerState.languagesModel.languages;
        return PopupMenuButton(
          child: child,
          itemBuilder: (BuildContext context) {
            return List.generate(
              languages.length,
              (index) {
                final languageModel = languages[index];
                return PopupMenuItem(
                  height: 40,
                  value: languageModel,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageModel.languageEnum.nativeName,
                      ),
                      CircularTick(
                        showTick: languageModel.isSelected,
                        enablePlaceHolder: true,
                        tickSize: 16,
                        placeHolderHeight: 16,
                        placeHolderWidth: 16,
                      ),
                    ],
                  ),
                );
              },
            );
          },
          onSelected: (value) {
            context
                .read<NewsLanguageChangeControllerCubit>()
                .selectLanguage(value.languageEnum);
          },
        );
      },
    );
  }
}
