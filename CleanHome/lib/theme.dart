import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';

//edit
mixin CustomTheme {
  static const MaterialColor neutralColors = MaterialColor(
    0xFF000000, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE0E0E0), //10%
      100: Color(0xffeeeeee), //20%
      200: Color(0xFF808080), //30%
      300: Color(0xFF4D4D4D), //40%
      400: Color(0xFF262626), //50%
      500: Color(0xFF000000), //60%
      600: Color(0xFF000000), //70%
      700: Color(0xFF000000), //80%
      800: Color(0xFF000000), //90%
      900: Color(0xFF000000), //100%
    },
  );
  static const MaterialColor primaryColors = MaterialColor(
    0xFF0BB8E3, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE2F6FC),
      100: Color(0xFFB6EAF7),
      200: Color(0xFF85DCF1),
      300: Color(0xFF54CDEB),
      400: Color(0xFF30C3E7),
      500: Color(0xFF0BB8E3),
      600: Color(0xFF0AB1E0),
      700: Color(0xFF08A8DC),
      800: Color(0xFF06A0D8),
      900: Color(0xFF0391D0),
    },
  );

  static const MaterialColor secondaryColors = MaterialColor(
    0x12aa9df, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE0E0E0), //10%
      100: Color(0xFFB3B3B3), //20%
      200: Color(0xFF808080), //30%
      300: Color(0xFF4D4D4D), //40%
      400: Color(0xFF262626), //50%
      500: Color(0xFF000000), //60%
      600: Color(0xFF000000), //70%
      700: Color(0xFF000000), //80%
      800: Color(0xFF000000), //90%
      900: Color(0xFF000000),
    },
  );

  static const double tabletBreakpoint = 1280;

  static final ThemeData theme1 = ThemeData(
    useMaterial3: true,
    dividerColor: Color(0xffb9c5db),
    fontFamily: 'Colibri',
    dialogBackgroundColor: Colors.white,
    dividerTheme: DividerThemeData(thickness: 0.5, color: Color(0xffb9c5db)),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ))),
    snackBarTheme:
        SnackBarThemeData(backgroundColor: Colors.white, elevation: 0),
    splashColor: primaryColors.shade400,
    highlightColor: primaryColors.shade200,
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(color: neutralColors.shade800),
        backgroundColor: Colors.white),
    appBarTheme:
        const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColors,
        onPrimary: Colors.white,
        secondary: secondaryColors,
        onSecondary: Colors.white,
        error: const Color(0xffB20D0E),
        onError: Colors.white,
        background: Colors.white,
        onBackground: neutralColors.shade500,
        surface: Colors.white,
        onSurface: neutralColors.shade700),
    textTheme: TextTheme(
        displayLarge: TextStyle(
          color: neutralColors.shade900,
          fontSize: 45,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -1.125,
        ),
        displayMedium: TextStyle(
          color: primaryColors.shade900,
          fontSize: 36,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.9,
        ),
        displaySmall: TextStyle(
          color: primaryColors.shade900,
          fontSize: 28,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.7,
        ),
        headlineLarge: TextStyle(
          color: neutralColors.shade900,
          fontSize: 22,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.55,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.45,
        ),
        titleLarge: TextStyle(
          color: neutralColors.shade800,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.45,
        ),
        headlineSmall: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.4,
        ),
        titleMedium: TextStyle(
          color: neutralColors.shade800,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          color: neutralColors.shade800,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.45,
        ),
        bodySmall: TextStyle(
          color: neutralColors.shade600,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.4,
        ),
        labelLarge: const TextStyle(
          color: neutralColors,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.4,
        ),
        titleSmall: TextStyle(
          color: primaryColors.shade900,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.35,
        ),
        labelMedium: const TextStyle(
          color: neutralColors,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.35,
        ),
        labelSmall: const TextStyle(
          color: neutralColors,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: CustomTheme.neutralColors.shade300, width: 2),
              borderRadius: BorderRadius.circular(10), // <-- Radius
            ))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),
            shadowColor: CustomTheme.neutralColors.shade50,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // <-- Radius
            ),
            padding: const EdgeInsets.all(16))),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Colors.lightGreen,
          width: 3,
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.lightGreen,
      labelColor: Colors.lightGreen,
    ),
  );
}
