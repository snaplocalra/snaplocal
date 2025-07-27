import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum GenderEnum {
  male(displayName: LocaleKeys.maleText, svgIcon: SVGAssetsImages.manNamaste),
  female(displayName: LocaleKeys.femaleText, svgIcon: SVGAssetsImages.womanNamaste),
  others(displayName: LocaleKeys.others, svgIcon: SVGAssetsImages.others),
  none(displayName: "",svgIcon: "");


  bool get isGenderAvalable => name != GenderEnum.none.name;

  final String displayName;
  final String svgIcon;
  const GenderEnum({required this.displayName, required this.svgIcon});

  factory GenderEnum.fromJson(String genderText) {
    switch (genderText) {
      case "male":
        return male;
      case "female":
        return female;
      case "others":
        return others;
      default:
        return none;
    }
  }
}
