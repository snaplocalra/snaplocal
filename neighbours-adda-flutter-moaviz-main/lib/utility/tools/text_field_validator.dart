import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/tools/text_field_regx.dart';

class TextFieldValidator {
  static String? emailValidator(String? value) {
    RegExp regex = RegExp(TextFieldValidatorRegx.email);
    RegExp comRegex = RegExp(r'\.com$');

    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.fieldCanTBeEmpty);
    } else if (!comRegex.hasMatch(value)) {
      return 'Email address should end with .com';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    } else if (value.trim().isEmpty) {
      return tr(LocaleKeys.invalidEntry);
    } else {
      return null;
    }
  }

  // static String? passwordValidator(String? value, {String? matcher}) {
  //   if (value == null || value.isEmpty) {
  //     return "Field can't be empty";
  //   } else if (matcher != null && value != matcher) {
  //     // check matcher to confirm password
  //     return "Password doesn't match";
  //   } else if (value.length < 8) {
  //     // Password length check
  //     return 'Password must be at least 8 characters long';
  //   }

  //   // Uppercase letter check
  //   if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
  //     return 'Password must contain at least one uppercase letter';
  //   }

  //   // Lowercase letter check
  //   if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
  //     return 'Password must contain at least one lowercase letter';
  //   }

  //   // Digit check
  //   if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
  //     return 'Password must contain at least one digit';
  //   }

  //   // Password is valid
  //   return null;
  // }

//confirm password validator
  static String? confirmPasswordValidator(String? text, {String? matcher}) {
    if (text == null || text.trim().isEmpty) {
      return tr(LocaleKeys.pleaseenterconfirmpassword);
    } else if (text != matcher) {
      return tr(LocaleKeys.passworddoesntmatch);
    } else {
      return null;
    }
  }

  static String? phoneNumberValidator(String? value, {int maxNumber = 10}) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.phonenumberfieldrequired);
    } else if (value.trim().isEmpty) {
      return tr(LocaleKeys.invalidEntry);
    } else if (value.length < maxNumber) {
      // return "Phone number must be $maxNumber digit";
      return tr(
          "${LocaleKeys.phonenumbermustbe} $maxNumber ${LocaleKeys.digit}");
    } else {
      return null;
    }
  }

  static String? standardValidator(String? value) {
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.fieldCanTBeEmpty);
    } else if (value.trim().isEmpty) {
      return tr(LocaleKeys.invalidEntry);
    } else {
      return null;
    }
  }

  //standard validator with min length
  static String? standardValidatorWithMinLength(
    String? value,
    int minLength, {
    bool isOptional = false,
  }) {
    if (isOptional && (value == null || value.isEmpty)) {
      return null;
    } else if (value == null || value.isEmpty) {
      return tr(LocaleKeys.fieldCanTBeEmpty);
    } else if (value.trim().isEmpty) {
      return tr(LocaleKeys.invalidEntry);
    } else if (value.length < minLength) {
      return tr(
          "${LocaleKeys.minimum} $minLength ${LocaleKeys.charactersRequired}");
    } else {
      return null;
    }
  }

  //wesite link validator
  static String? websiteLinkValidator(String? value) {
    RegExp regex = RegExp(TextFieldValidatorRegx.websiteLink);
    if (value == null || value.isEmpty) {
      return tr(LocaleKeys.fieldCanTBeEmpty);
    } else if (!regex.hasMatch(value)) {
      return tr(LocaleKeys.enteravalidwebsitelink);
    } else if (value.trim().isEmpty) {
      return tr(LocaleKeys.invalidEntry);
    } else {
      return null;
    }
  }
}
