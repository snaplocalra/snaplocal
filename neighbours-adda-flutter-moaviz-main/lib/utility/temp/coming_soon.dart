import 'package:designer/utility/theme_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

void comingSoon() {
  ThemeToast.successToast("${tr(LocaleKeys.comingSoon)}...");
}
