import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/circular_tick.dart';
import 'package:snap_local/utility/localization/model/language_model.dart';

class LanguageCardWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final void Function(LanguageModel selectedLanguage) onTap;
  const LanguageCardWidget({
    super.key,
    required this.languageModel,
    required this.onTap,
  });

  TextStyle textStyle({
    required bool isSelected,
    double? fontSize,
    FontWeight? fontWeight,
    double? textColorOpacity,
  }) {
    return TextStyle(
      color: languageModel.isSelected
          ? Colors.white.withOpacity(textColorOpacity ?? 1)
          : Colors.black.withOpacity(textColorOpacity ?? 1),
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(languageModel),
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(214, 210, 210, 1)),
          borderRadius: BorderRadius.circular(15),
          color: languageModel.isSelected
              ? const Color.fromRGBO(0, 25, 104, 1)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageModel.languageEnum.nativeName,
                    style: textStyle(
                      isSelected: languageModel.isSelected,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageModel.languageEnum.englishName,
                    style: textStyle(
                      isSelected: languageModel.isSelected,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColorOpacity: 0.6,
                    ),
                  ),
                ],
              ),
            ),
            CircularTick(
              showTick: languageModel.isSelected,
              enablePlaceHolder: true,
              tickSize: 18,
              placeHolderHeight: 18,
              placeHolderWidth: 18,
            ),
          ],
        ),
      ),
    );
  }
}
