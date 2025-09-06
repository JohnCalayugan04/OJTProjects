import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SupplySystemApp());
}

class SupplySystemApp extends StatelessWidget {
  const SupplySystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F2A52)),
      textTheme: GoogleFonts.poppinsTextTheme(),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SupplySystem',
      theme: baseTheme,
      home: const LoginPage(),
    );
  }
}

