class TextFieldValidatorRegx {
  static const email =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";

  //website link regx
  static const websiteLink =
      r'^(http|https)://[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+([/?].*)?$';
}

class TextFieldInputFormattersRegx {
  static const number = "0-9";
  static const lowerCase = "a-z";
  static const upperCase = "A-Z";
  static const specialCharacters = '!@#\$%^&*(),.?":{}|<>]';
}

class TextFormatter {
  static String removeBlankSpace(String text) =>
      text.replaceAll(RegExp(r'\n\n\n+'), '\n');
}
