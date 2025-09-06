import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _barHeight = 55.0;

class RedBar extends StatelessWidget {
  const RedBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: _barHeight,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD72626), Color(0xFFB71C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 6,
                  spreadRadius: -2,
                  offset: Offset(-2, -2),
                ),
              ],
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
                bottom:
                    BorderSide(color: Colors.black.withValues(alpha: 0.4), width: 2),
              ),
            ),
            child: Stack(
              children: [
                // Light reflection strip at top edge
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.4),
                          Colors.transparent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // Content row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      // Back button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      // Logo
                      Image.asset('assets/images/SSlogo2.png', height: 30),
                      const SizedBox(width: 10),

                      // Title
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            "SUPPLY SYSTEM INTELLIGENT SOFTWARE",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // const SizedBox(height: 10),
        //
        // const SizedBox(height: 10),
        // Bottom footer bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: _barHeight,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB71C1C),
                  Color(0xFFF14444),
                  Color(0xFFB71C1C)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(0, -3),
                ),
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 6,
                  spreadRadius: -2,
                  offset: Offset(2, 2),
                ),
              ],
              border: Border(
                top: BorderSide(color: Colors.black.withValues(alpha: 0.4), width: 2),
                bottom:
                    BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              "v.4.1.78.6",
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
