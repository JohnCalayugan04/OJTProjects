import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoLayout extends StatelessWidget{
  const LogoLayout ({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaleFactor = (size.width / 400).clamp(0.8, 1.5);

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 2* scaleFactor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo & title
            Image.asset(
              'assets/images/SSlogo.png',
              fit: BoxFit.contain,
              width: 65 * scaleFactor,
            ),
            Text(
              "SupplySystem",
              style: GoogleFonts.poppins(
                fontSize: 28 * scaleFactor,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Intelligent Software",
              style: GoogleFonts.poppins(
                fontSize: 16 * scaleFactor,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}