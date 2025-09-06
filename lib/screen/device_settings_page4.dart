import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_gen_user/Widgets/logolayout.dart';
import '../widgets/background.dart';
import '../widgets/red_bar.dart';
import '../screen/device_settings_page5.dart';
import 'device_settings_page6.dart';

class DeviceSettingsPage4 extends StatefulWidget {
  final String companyCode;
  final String deviceId;
  final String selectedComPort;
  final String selectedBaudRate;

  const DeviceSettingsPage4({
    super.key,
    required this.companyCode,
    required this.deviceId,
    required this.selectedComPort,
    required this.selectedBaudRate,
  });

  @override
  State<DeviceSettingsPage4> createState() => _DeviceSettingsPage4State();
}

class _DeviceSettingsPage4State extends State<DeviceSettingsPage4> {
  String? _rfidSelectedComPort;
  String? _rfidsSelectedBaudRate;
  final TextEditingController _scriptController = TextEditingController();

  final List<String> _rfidComPorts = ['COM1', 'COM2', 'COM3', 'COM4'];
  final List<String> _rfidBaudRates = [
    '9600',
    '14400',
    '19200',
    '38400',
    '57600',
    '115200'
  ];

  @override
  void dispose() {
    _scriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

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
                  final size = MediaQuery
                      .of(context)
                      .size;
                  final scaleFactor = (size.width / 400).clamp(0.8, 1.5);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LogoLayout(),

                      const SizedBox(height: 20),

                      // blurred box
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
                                child: Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(height: 32),

                                      // Title
                                      Text(
                                        "RFID READER SETTINGS",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 16),

                                      // COM Port & Baud Rate
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildDropdown(
                                              label: "Select COM Port",
                                              value: _rfidSelectedComPort,
                                              hint: "COM",
                                              items: _rfidComPorts,
                                              onChanged: (val) =>
                                                  setState(() =>
                                                  _rfidSelectedComPort = val),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildDropdown(
                                              label: "Select Baud Rate",
                                              value: _rfidsSelectedBaudRate,
                                              hint: "9600",
                                              items: _rfidBaudRates,
                                              onChanged: (val) =>
                                                  setState(() =>
                                                  _rfidsSelectedBaudRate = val),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 24),

                                      // Script Parameters
                                      Text(
                                        "Script Parameters",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: _scriptController,
                                        maxLines: 3,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Enter Script Parameters",
                                          alignLabelWithHint: true,
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // Buttons
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          OutlinedButton.icon(
                                            onPressed: () =>
                                                _navigateToNextPage(script: ''),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              side: const BorderSide(
                                                  color: Colors.red),
                                            ),
                                            icon: const Icon(Icons.fast_forward,
                                                color: Colors.red),
                                            label: const Text(
                                              "Skip",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              if (_rfidSelectedComPort !=
                                                  null &&
                                                  _rfidsSelectedBaudRate !=
                                                      null) {
                                                _navigateToNextPage(
                                                    script:
                                                    _scriptController.text);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Please select both COM Port and Baud Rate."),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.black,
                                            ),
                                            icon: const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white),
                                            label: const Text(
                                              "Next",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  void _navigateToNextPage({required String script}) {
    final page6 = DeviceSettingsPage6(
      companyCode: widget.companyCode,
      deviceId: widget.deviceId,
      selectedComPort: widget.selectedComPort,
      selectedBaudRate: widget.selectedBaudRate,
      rfidComPort: _rfidSelectedComPort ?? '',
      rfidBaudRate: _rfidsSelectedBaudRate ?? '',
      script: script,
      machines: [],
    );

    //
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeviceSettingsPage5(
          machines: [],
          companyCode: page6.companyCode,
          deviceId: page6.deviceId,
          selectedComPort: page6.selectedComPort,
          selectedBaudRate: page6.selectedBaudRate,
          rfidComPort: page6.rfidComPort,
          rfidBaudRate: page6.rfidBaudRate,
          script: page6.script,
        ),
      ),
    );
  }

}
