import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MsColors {
  static Color primary = const Color(0xFF1a80d1);
  static Color secondary = Color.fromARGB(255, 6, 63, 109);
  static Color text = Color(0xFF999999);
  static Color light = const Color(0xFFF5F5F5);
  static Color medium = Color.fromARGB(255, 145, 161, 173);
}

class MsThemeMode {
  ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: MsColors.primary,
      scaffoldBackgroundColor: MsColors.primary,
      splashColor: MsColors.primary.withOpacity(.3),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: MsColors.primary, circularTrackColor: MsColors.light),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white, unselectedItemColor: MsColors.medium, selectedItemColor: MsColors.medium, selectedLabelStyle: TextStyle(fontSize: 10.0), unselectedLabelStyle: TextStyle(fontSize: 10.0)),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(10.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(titleMedium: GoogleFonts.plusJakartaSans(color: Colors.black), bodyMedium: GoogleFonts.plusJakartaSans(color: Colors.black)),
      appBarTheme: AppBarTheme(
          backgroundColor: MsColors.primary,
          toolbarHeight: 60.0,
          shadowColor: Color(0xFFDDDDDD),
          elevation: 0.0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: MsColors.text.withOpacity(.6),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.white54,
        ),
        labelColor: Colors.white,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: MsColors.primary)),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(fontSize: 15.0, height: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      )),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
      ));

  ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: MsColors.primary,
      scaffoldBackgroundColor: MsColors.primary,
      splashColor: MsColors.primary.withOpacity(.3),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: MsColors.primary, circularTrackColor: MsColors.light),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black87, unselectedItemColor: MsColors.text, selectedItemColor: MsColors.secondary, selectedLabelStyle: TextStyle(fontSize: 10.0), unselectedLabelStyle: TextStyle(fontSize: 10.0)),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(10.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: MsColors.light),
        ),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(titleMedium: GoogleFonts.plusJakartaSans(color: Colors.white), bodyMedium: GoogleFonts.plusJakartaSans(color: Colors.white)),
      appBarTheme: AppBarTheme(
          backgroundColor: MsColors.primary,
          toolbarHeight: 60.0,
          shadowColor: Color(0xFFDDDDDD),
          elevation: 0.0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: MsColors.text.withOpacity(.6),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.white54,
        ),
        labelColor: Colors.white,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 3.0, color: MsColors.primary)),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(fontSize: 15.0, height: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        behavior: SnackBarBehavior.floating,
        elevation: 0.0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      )),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(width: 1.0, color: Colors.grey.shade300)),
      ));
}

extension ColorSchemeExtension on ColorScheme {
  Color get secondColor => brightness == Brightness.light ? MsColors.secondary : MsColors.secondary;

  Color get lightColor => brightness == Brightness.light ? MsColors.light : const Color(0xFF2d2d2d);

  Color get greyColor => brightness == Brightness.light ? MsColors.text : const Color(0xFF868686);

  Color get textColor => brightness == Brightness.light ? const Color(0xFF000000) : const Color(0xFFffffff);

  Color get backgroundColor => brightness == Brightness.light ? const Color(0xFFFFFFFF) : Colors.black;

  Color get settingsHeading => brightness == Brightness.light ? Colors.black : const Color(0xFF666666);

  Color get dynamicColor => brightness == Brightness.light ? MsColors.primary : MsColors.secondary;

  Color get appBarColor => brightness == Brightness.light ? MsColors.primary : Colors.black;

  Color get oppositeColor => brightness == Brightness.light ? Colors.black : Colors.white;
}
