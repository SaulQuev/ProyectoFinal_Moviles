import 'package:flutter/material.dart';

class StylesApp {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color.fromARGB(232, 65, 194, 5)));
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: const Color.fromARGB(253, 29, 88, 1)));
  }
}
