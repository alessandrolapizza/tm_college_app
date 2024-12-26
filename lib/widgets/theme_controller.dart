import "package:flutter/material.dart";
import "./app.dart";

class ThemeController extends StatelessWidget {
  final Color? color;

  final Widget? child;

  ThemeController({
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Color? adaptedColor;

    // bool dark = ThemeData.estimateBrightnessForColor(color!) == Brightness.dark;

    // if (ThemeData.estimateBrightnessForColor(color!) == Brightness.dark &&
    //     color!.value != App.defaultColorThemeValue) {
    //   adaptedColor = color;
    // } else if (ThemeData.estimateBrightnessForColor(color!) !=
    //     Brightness.dark) {
    //   adaptedColor = Colors.black;
    // } else {
    //   adaptedColor = Color(App.defaultColorThemeValue);
    // }

    Color seedColor = color!;

    // 2) Générer les ColorSchemes (clair et sombre)
    final ColorScheme lightColorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    final ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    // 3) Créer les thèmes à partir de ces ColorSchemes
    final ThemeData lightTheme = ThemeData(
      colorScheme: lightColorScheme,
      // textSelectionTheme: TextSelectionThemeData(
      //   cursorColor: color, // Couleur du curseur
      //   selectionColor: color, // Couleur de la sélection
      //   selectionHandleColor: color, // Couleur de la poignée de sélection
      // ),
      // useMaterial3: true,
      //  highlightColor: Colors.transparent,
    );

    final ThemeData darkTheme = ThemeData(
      colorScheme: darkColorScheme,
      // textSelectionTheme: TextSelectionThemeData(
      //   cursorColor: color, // Couleur du curseur
      //   selectionColor: color, // Couleur de la sélection
      //   selectionHandleColor: color, // Couleur de la poignée de sélection
      // ),
      // useMaterial3: true,
      // highlightColor: Colors.transparent,
    );

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      child: child!,
      data: isDarkMode ? darkTheme : lightTheme,
    );
  }
}
//       data: Theme.of(context).copyWith(
//         primaryColor: color,
//         primaryTextTheme: TextTheme(
//           headlineSmall: TextStyle(color: dark ? Colors.white : Colors.black),
//         ),
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: App.toMaterialColor(color!.value),
//         ),
//         primaryIconTheme: IconThemeData(
//           color: dark ? Colors.white : Colors.black,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ButtonStyle(
//             foregroundColor:
//                 MaterialStateProperty.all(dark ? Colors.white : Colors.black),
//           ),
//         ),
//         outlinedButtonTheme: OutlinedButtonThemeData(
//           style: OutlinedButton.styleFrom(
//             foregroundColor: adaptedColor,
//           ),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//               foregroundColor:
//                   adaptedColor //MaterialStateProperty.all(adaptedColor),
//               ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           labelStyle: TextStyle(color: adaptedColor),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: adaptedColor!),
//           ),
//         ),
//       ),
//       child: child!,
//     );
//   }
// }
