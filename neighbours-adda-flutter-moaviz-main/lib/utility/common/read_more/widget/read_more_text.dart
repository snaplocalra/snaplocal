import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/widgets/selectable_linkify_text.dart';
import 'package:snap_local/utility/common/read_more/logic/read_more_controller/read_more_controller_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ReadMoreText extends StatelessWidget {
  final String text;
  final String? readMoreText;
  final String? readLessText;
  final TextStyle? style;
  final TextStyle? readMoreOptionTextStyle;

  /// The text length at which the ReadMore functionality will be enabled.
  /// Use this parameter to specify the threshold length for enabling the "Read More" feature.
  /// For example, if set to 150, the ReadMore functionality will be triggered when the text
  /// length exceeds 150 characters, allowing users to expand long texts.
  /// @param readMoreEnableTextLength The text length for enabling the ReadMore functionality.
  final int readMoreEnableTextLength;

  final int readLessLine;
  const ReadMoreText(
    this.text, {
    super.key,
    this.style,
    this.readMoreText,
    this.readLessText,
    this.readMoreOptionTextStyle,
    this.readMoreEnableTextLength = 333, //default value
    this.readLessLine = 4,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadMoreControllerCubit(readLessLine: readLessLine)
        ..toggleEnableReadMore(text.length > readMoreEnableTextLength),
      child: BlocBuilder<ReadMoreControllerCubit, ReadMoreControllerState>(
        builder: (context, readMoreControllerState) {
          final isTextExpanded = readMoreControllerState.maxLine == null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableLinkifyText(
                text: text,
                textStyle: style,
                maxLines: readMoreControllerState.maxLine,
              ),
              Visibility(
                visible: readMoreControllerState.enableReadMore,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (isTextExpanded) {
                        context.read<ReadMoreControllerCubit>().readLess();
                      } else {
                        context.read<ReadMoreControllerCubit>().readMore();
                      }
                    },
                    child: Text(
                      isTextExpanded
                          ? (readLessText ?? tr(LocaleKeys.readLess))
                          : (readMoreText ?? tr(LocaleKeys.readMore)),
                      style: readMoreOptionTextStyle ??
                          const TextStyle(
                            color: Colors.indigo,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
