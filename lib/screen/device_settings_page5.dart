import 'package:flutter/material.dart';
import 'package:next_gen_user/screen/device_settings_page6.dart';
import '../widgets/background.dart';
import '../widgets/red_bar.dart';
import 'package:next_gen_user/Widgets/logolayout.dart';

class DeviceSettingsPage5 extends StatelessWidget {
  final List<Map<String, String>> machines;
  final String companyCode;
  final String deviceId;
  final String selectedComPort;
  final String selectedBaudRate;
  final String script;
  final String rfidComPort;
  final String rfidBaudRate;

  const DeviceSettingsPage5({
    super.key,
    required this.machines,
    required this.companyCode,
    required this.deviceId,
    required this.selectedComPort,
    required this.selectedBaudRate,
    required this.script,
    required this.rfidComPort,
    required this.rfidBaudRate,
  });

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

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoLayout(),
                      const SizedBox(height: 20),

                      // blurred box
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: cardWidth,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.black.withValues(alpha: 0.4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blueAccent.withValues(alpha: 0.8),
                                      Colors.indigoAccent
                                          .withValues(alpha: 0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Machine Settings',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              // Header
                              Container(
                                color: Colors.blueGrey.withValues(alpha: 0.7),
                                child: Row(
                                  children: [
                                    _buildHeaderCell('Machine Type', 1),
                                    _buildHeaderCell('Machine Tag', 1),
                                    _buildHeaderCell('Machine Name', 1),
                                    _buildHeaderCell('Controller ID', 1),
                                  ],
                                ),
                              ),

                              // Rows
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  itemCount: 20,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: i.isEven
                                            ? Colors.white
                                                .withValues(alpha: 0.05)
                                            : Colors.white
                                                .withValues(alpha: 0.1),
                                      ),
                                      child: Row(
                                        children: [
                                          _buildBodyCell('Type $i', 1),
                                          _buildBodyCell('Tag $i', 1),
                                          _buildBodyCell('Name $i', 1),
                                          _buildDropdownCell(1),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // skip logic
                                    },
                                    icon: const Icon(Icons.fast_forward,
                                        color: Colors.red),
                                    label: const Text("Skip"),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeviceSettingsPage6(
                                            machines: machines,
                                            companyCode: companyCode,
                                            deviceId: deviceId,
                                            selectedComPort: selectedComPort,
                                            selectedBaudRate: selectedBaudRate,
                                            script: script,
                                            rfidComPort: rfidComPort,
                                            rfidBaudRate: rfidBaudRate,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_forward,
                                        color: Colors.white),
                                    label: const Text("Next"),
                                  ),
                                ],
                              ),
                            ],
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

  // Header cell
  Widget _buildHeaderCell(String text, double scaleFactor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Body cell
  Widget _buildBodyCell(String text, double scaleFactor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Dropdown in table cell
  Widget _buildDropdownCell(double scaleFactor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          dropdownColor: Colors.black87,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14 * scaleFactor,
          ),
          items: List.generate(
            5,
            (index) => DropdownMenuItem(
              value: 'Controller $index',
              child: Text('Controller $index'),
            ),
          ),
          onChanged: (value) {},
        ),
      ),
    );
  }
}
