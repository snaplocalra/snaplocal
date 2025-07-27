import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum AuthDescriptionType {
  signup1(
    description: LocaleKeys.signup1Description,
    svgPath: SVGAssetsImages.signup1,
  ),
  signup2(
    description: LocaleKeys.signup2Description,
    svgPath: SVGAssetsImages.signup2,
  ),
  forgotPassword(
    description: LocaleKeys.forgotPasswordDescription,
    svgPath: SVGAssetsImages.forgotPassword,
  ),
  createPassword(
    description: LocaleKeys.createPasswordDescription,
    svgPath: SVGAssetsImages.createPassword,
  ),
  ;

  final String description;
  final String svgPath;

  const AuthDescriptionType({
    required this.description,
    required this.svgPath,
  });
}
