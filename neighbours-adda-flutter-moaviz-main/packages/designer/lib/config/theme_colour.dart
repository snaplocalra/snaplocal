import 'package:flutter/material.dart';

class ThemeColor {
  static Color color = const Color(0xff1c39bb);

  ///Pass the colour hexcode as argument
  ///Example: primarySwatchThemeColor(0xFFF7F7F7)
  static MaterialColor primarySwatchThemeColor(int themeColour) {
    //Update the theme colour
    color = Color(themeColour);
    return MaterialColor(
      themeColour,
      <int, Color>{
        50: Color(themeColour),
        100: Color(themeColour),
        200: Color(themeColour),
        300: Color(themeColour),
        400: Color(themeColour),
        500: Color(themeColour),
        600: Color(themeColour),
        700: Color(themeColour),
        800: Color(themeColour),
        900: Color(themeColour),
      },
    );
  }
}
