import 'package:flutter/material.dart';

Map<String, Color> colors = {
  'background': Colors.white,
  'primary': const Color.fromRGBO(83, 42, 120, 1),
  'secondary': const Color.fromRGBO(95, 173, 158, 1),
  'text': const Color.fromARGB(255, 35, 34, 34),
};

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: colors['background'],
  backgroundColor: colors['background'],
  primaryColor: colors['primary'],
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: colors['secondary'],
  ),
  textTheme: TextTheme(
    titleSmall: TextStyle(
      color: colors['primary'],
    ),
  ),
  iconTheme: IconThemeData(
    color: colors['primary'],
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color.fromARGB(255, 84, 76, 76),
    centerTitle: true,
    elevation: 0.0,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: colors['text'],
      elevation: 0.0,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: colors['background'],
      primary: colors['text'],
      side: BorderSide(
        color: colors['primary'] as Color,
        width: 3.0,
        style: BorderStyle.solid,
      ),
      elevation: 0.0,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: colors['primary'],
    elevation: 0.0,
  ),
);

InputDecoration getInputDecoration(
    String? labelName, String? hintText, IconData? iconData) {
  Color? color = colors['primary'];
  return InputDecoration(
    icon: iconData != null
        ? Icon(
            color: color,
            iconData,
          )
        : null,
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 12),
    labelText: labelName,
    labelStyle: TextStyle(color: color),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: color!, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(5),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
