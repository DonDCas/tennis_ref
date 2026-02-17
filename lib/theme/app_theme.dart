import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  
  static const Color primaryColor = Colors.indigo;
  static const double defaultRadius = 10.0;
  static const String defaultFont = 'Roboto';

  static ThemeData getTheme({String? fontFamily, double? borderRadius}) {
    TextTheme textTheme;
    try{
      textTheme = GoogleFonts.getTextTheme(fontFamily ?? defaultFont);
    } catch(e){
      print("Error cargando GoogleFont, usando fuente por defecto: $e");
      textTheme = GoogleFonts.getTextTheme(defaultFont);
    }
    
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.getFont(fontFamily ?? defaultFont).fontFamily,
      
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(
            borderRadius ?? defaultRadius
          )
        ),
      ),      
      
      brightness: Brightness.dark, 
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}