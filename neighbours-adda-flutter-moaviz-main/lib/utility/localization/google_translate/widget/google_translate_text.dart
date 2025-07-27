import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/google_translate/google_translate/cubit/google_translate_cubit.dart';
import 'package:snap_local/utility/localization/google_translate/repository/google_free_translator.dart';
import 'package:snap_local/utility/localization/google_translate/repository/google_paid_translator.dart';
import 'package:snap_local/utility/localization/google_translate/repository/translation_repository.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';

class GoogleTranslateText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String? targetLanguageCode;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool enablePaidTranslation;
  final bool enableTranslation;
  const GoogleTranslateText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.targetLanguageCode,
    this.maxLines,
    this.overflow,
    this.enablePaidTranslation = false,
    this.enableTranslation = true,
  });

  @override
  State<GoogleTranslateText> createState() => _GoogleTranslateTextState();
}

class _GoogleTranslateTextState extends State<GoogleTranslateText> {
  late GoogleTranslateCubit googleTranslateCubit =
      GoogleTranslateCubit(sourceText: widget.text);

  late TranslationRepository translationRepository =
      widget.enablePaidTranslation
          ? GooglePaidTranslator(LocaleManager.english.languageCode)
          : GoogleFreeTranslator();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.enableTranslation) {
      googleTranslateCubit.translateText(
        widget.targetLanguageCode ??
            EasyLocalization.of(context)!.locale.languageCode,
        translationRepository: translationRepository,
      );
    }
  }

  @override
  void didUpdateWidget(covariant GoogleTranslateText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      if (widget.enableTranslation) {
        googleTranslateCubit.translateText(
          widget.targetLanguageCode ??
              EasyLocalization.of(context)!.locale.languageCode,
          translationRepository: translationRepository,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: googleTranslateCubit,
      child: BlocBuilder<GoogleTranslateCubit, GoogleTranslateState>(
        builder: (context, googleTranslateState) {
          return Text(
            googleTranslateState.translatedText,
            textAlign: widget.textAlign,
            style: widget.style,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
          );
        },
      ),
    );
  }
}
