import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      outlineVariant: borderColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.inter().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: appTextSecondaryColor),
    textTheme: GoogleFonts.interTextTheme(),
    unselectedWidgetColor: Colors.black,
    dividerColor: borderColor,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: Colors.white,
    ),
    cardColor: cardColor,
    appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: primaryColor)),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: dialogShape()),
    navigationBarTheme: NavigationBarThemeData(labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 10))),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(Colors.white),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      outlineVariant: borderColor.withValues(alpha:0.4),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: primaryColor),
    ),
    scaffoldBackgroundColor: scaffoldColorDark,
    fontFamily: GoogleFonts.inter().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: scaffoldSecondaryDark),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.interTextTheme(),
    unselectedWidgetColor: Colors.white60,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: scaffoldSecondaryDark,
    ),
    dividerColor: dividerDarkColor,
    cardColor: scaffoldSecondaryDark,
    dialogTheme: DialogTheme(
      backgroundColor: scaffoldSecondaryDark,
      surfaceTintColor: Colors.transparent,
      shape: dialogShape()),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 10, color: Colors.white))),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
