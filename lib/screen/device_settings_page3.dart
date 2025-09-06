import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_gen_user/Widgets/logolayout.dart';
import 'package:next_gen_user/screen/device_settings_page4.dart';
import 'package:next_gen_user/screen/device_settings_page6.dart';
import 'package:next_gen_user/widgets/red_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background.dart';
import 'device_settings_page6.dart';

class DeviceSettingsPage3 extends StatefulWidget {
  final String companyCode;
  final String deviceId;

  const DeviceSettingsPage3({
    required this.companyCode,
    required this.deviceId,
    super.key,
  });

  @override
  State<DeviceSettingsPage3> createState() => _DeviceSettingsPage3State();
}

class _DeviceSettingsPage3State extends State<DeviceSettingsPage3> {
  String? _selectedComPort;
  String? _selectedBaudRate;
  bool _isLoading = false;

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4'];
  final List<String> _baudRates = [
    '9600',
    '14400',
    '19200',
    '38400',
    '57600',
    '115200'
  ];

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedComPort = prefs.getString('comPort');
    _selectedBaudRate = prefs.getString('baudRate');
    setState(() {});
  }

  Future<void> _saveSelections() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selectedComPort != null) {
      await prefs.setString('comPort', _selectedComPort!);
    }
    if (_selectedBaudRate != null) {
      await prefs.setString('baudRate', _selectedBaudRate!);
    }
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
                                padding: EdgeInsets.all(16 * scaleFactor),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _kv("Device ID:", widget.deviceId),
                                    _kv("Company Code:", widget.companyCode),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "API URL:",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "https://www.api-url/endpoint",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20 * scaleFactor),

                                    // Dropdowns
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select COM Port",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(height: 6),
                                              DropdownButtonFormField<String>(
                                                value: _selectedComPort,
                                                hint: const Text("COM"),
                                                items: _comPorts
                                                    .map((port) =>
                                                        DropdownMenuItem(
                                                          value: port,
                                                          child: Text(port),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) => setState(
                                                    () => _selectedComPort =
                                                        value),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Select Baud Rate",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(height: 6),
                                              DropdownButtonFormField<String>(
                                                value: _selectedBaudRate,
                                                hint: const Text("9600"),
                                                items: _baudRates
                                                    .map((rate) =>
                                                        DropdownMenuItem(
                                                          value: rate,
                                                          child: Text(rate),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) => setState(
                                                    () => _selectedBaudRate =
                                                        value),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20 * scaleFactor),

                                    if (_isLoading)
                                      const Center(
                                          child: CircularProgressIndicator())
                                    else
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.arrow_forward,
                                                        color: Colors.white),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "NEXT",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (_selectedComPort == null ||
                                                  _selectedBaudRate == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Please select COM port and Baud Rate"),
                                                  ),
                                                );
                                                return;
                                              }

                                              setState(() => _isLoading = true);
                                              await _saveSelections();
                                              setState(
                                                  () => _isLoading = false);


                                              final page6 = DeviceSettingsPage6(
                                                companyCode: widget.companyCode,
                                                deviceId: widget.deviceId,
                                                selectedComPort:
                                                    _selectedComPort ?? '',
                                                selectedBaudRate:
                                                    _selectedBaudRate ?? '',
                                                machines: [],
                                                script: '',
                                                rfidComPort: '',
                                                rfidBaudRate: '',
                                              );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      DeviceSettingsPage4(
                                                    companyCode:
                                                        page6.companyCode,
                                                    deviceId: page6.deviceId,
                                                    selectedComPort:
                                                        page6.selectedComPort,
                                                    selectedBaudRate:
                                                        page6.selectedBaudRate,
                                                  ),
                                                ),
                                              );
                                            }),
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

  //widget for 2 dropbars
  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k,
              style: GoogleFonts.poppins(
                  color: Colors.white.withValues(alpha: 0.9))),
          Text(v,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
