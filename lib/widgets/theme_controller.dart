import "package:flutter/material.dart";
import "./app.dart";

class ThemeController extends StatelessWidget {
  final Color color;

  final Widget child;

  ThemeController({
    @required this.color,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Color adaptedColor;

    bool dark = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;

    if (ThemeData.estimateBrightnessForColor(color) == Brightness.dark &&
        color.value != App.defaultColorThemeValue) {
      adaptedColor = color;
    } else if (ThemeData.estimateBrightnessForColor(color) != Brightness.dark) {
      adaptedColor = Colors.black;
    } else {
      adaptedColor = Color(App.defaultColorThemeValue);
    }
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: color,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(color: dark ? Colors.white : Colors.black),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: App.toMaterialColor(color.value),
        ),
        primaryIconTheme: IconThemeData(
          color: dark ? Colors.white : Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(dark ? Colors.white : Colors.black),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(adaptedColor),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(adaptedColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: adaptedColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: adaptedColor),
          ),
        ),
      ),
      child: child,
    );
  }
}
