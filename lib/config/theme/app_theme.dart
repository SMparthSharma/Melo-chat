import 'package:flutter/material.dart';

class AppTheme {
  // Define the primary color
  static const primaryColor = Color(0xFFEB3434);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Colors
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Color(0xFF8E8E93),
      surface: Colors.white,
      onSurface: Colors.black,
      // Adding complementary colors that work well with #acdde0
      tertiary: Color(0xFF7CBEC2), // Slightly darker shade for depth
      onPrimary:
          Colors.black87, // Dark text on primary color for better contrast
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // Textfiled theme
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(width: 2, color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(width: 2, color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide(width: 2, color: Colors.grey),
      ),

    ),
  );
}
