import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_gen_user/Widgets/logolayout.dart';
import 'package:next_gen_user/widgets/red_bar.dart';
import '../widgets/background.dart';
import '../screen/device_settings_page3.dart';
import 'dart:ui';

class DeviceSettingsPage extends StatefulWidget {
  final String companyCode;

  const DeviceSettingsPage({
    required this.companyCode,
    super.key,
  });

  @override
  State<DeviceSettingsPage> createState() => _DeviceSettingsPageState();
}

class _DeviceSettingsPageState extends State<DeviceSettingsPage> {
  final _deviceIdController = TextEditingController();

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          const RedBar(),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20 + bottomInset),
              child: LayoutBuilder(
                builder: (context, c) {
                  final maxW = c.maxWidth;
                  final cardWidth = maxW < 600 ? maxW - 40 : 520.0;
                  final size = MediaQuery.of(context).size;
                  final scaleFactor = (size.width / 400).clamp(0.8, 1.5);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoLayout(),
                      SizedBox(height: 20 * scaleFactor),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: cardWidth,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white70.withValues(
                                          alpha: 0.08 + (0.02 * scaleFactor)),
                                      Colors.white24.withValues(
                                          alpha: 0.03 + (0.01 * scaleFactor)),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color:
                                        Colors.blueGrey.withValues(alpha: 0.2),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                    BoxShadow(
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(-5, -5),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(15 * scaleFactor),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Form(
                                      child: _buildTextField(
                                        controller: _deviceIdController,
                                        hint: "Device ID",
                                        obscure: false,
                                        icon: Icons.computer,
                                        scaleFactor: scaleFactor,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter Device ID";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20 * scaleFactor),

                                    // Company code & API info
                                    Text(
                                      "Company Code:",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12 * scaleFactor,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      widget.companyCode.isEmpty
                                          ? "N/A"
                                          : widget.companyCode,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13 * scaleFactor,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "API URL:",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12 * scaleFactor,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "https://www.api-url/endpoint",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13 * scaleFactor,
                                      ),
                                    ),
                                    SizedBox(height: 20 * scaleFactor),

                                    // Next button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: _onNextPressed,
                                        child: Ink(
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Icon(Icons.arrow_forward,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(
                                                  "NEXT",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required double scaleFactor,
    IconData? icon,
    Widget? suffix,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha:0.05),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20 * scaleFactor,
          vertical: 16 * scaleFactor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }

  void _onNextPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceSettingsPage3(
          companyCode: widget.companyCode,
          deviceId: _deviceIdController.text.trim(),
        ),
      ),
    );
  }
}
