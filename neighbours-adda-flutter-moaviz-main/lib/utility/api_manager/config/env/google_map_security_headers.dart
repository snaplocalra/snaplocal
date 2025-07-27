//Security header:
import 'dart:io';

Map<String, dynamic>? googleMapSecurityHeaders() {
  if (Platform.isAndroid) {
    const sha1 = "D4B7669FEE46D63B2E9FC96501792837EFD36239";

    return {
      'X-Android-Package': 'com.na.snaplocal',
      'X-Android-Cert': sha1,
    };
  } else if (Platform.isIOS) {
    return {
      'X-IOS-Bundle-Identifier': 'com.snaplocal.app',
    };
  }
  return null;
}
