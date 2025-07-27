import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/news_reporter_name_controller/news_reporter_name_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class NewsContributorNameChangeDialog extends StatelessWidget {
  const NewsContributorNameChangeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String newsReporterName = context
        .read<NewsReporterNameControllerCubit>()
        .state
        .newsReporter!
        .name;
    return AlertDialog.adaptive(
      titlePadding: const EdgeInsets.fromLTRB(
        10,
        15,
        10,
        5,
      ),
      contentPadding: const EdgeInsets.all(10),
      title: const Text(
        "Edit Contributor Name",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      content: ThemeTextFormField(
        initialValue: newsReporterName,
        style: const TextStyle(
          fontSize: 14,
        ),
        onChanged: (value) {
          newsReporterName = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            tr(LocaleKeys.cancel),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            //Assign the reporter name
            context
                .read<NewsReporterNameControllerCubit>()
                .assignContributorName(newsReporterName);
            Navigator.of(context).pop();
          },
          child: Text(
            tr(LocaleKeys.save),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
