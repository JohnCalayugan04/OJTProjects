import 'package:flutter/material.dart';
import '../Widgets/logolayout.dart';
import '../Widgets/background.dart';
import '../Widgets/red_bar.dart';

class DeviceSettingsPage6 extends StatelessWidget {
  final String companyCode;
  final String deviceId;
  final List<Map<String, String>> machines;
  final String selectedComPort;
  final String selectedBaudRate;
  final String script;
  final String rfidComPort;
  final String rfidBaudRate;

  const DeviceSettingsPage6({
    super.key,
    required this.companyCode,
    required this.deviceId,
    required this.machines,
    required this.selectedComPort,
    required this.selectedBaudRate,
    required this.script,
    required this.rfidComPort,
    required this.rfidBaudRate,
  });

  Widget buildSpecCard(
      String title, List<Map<String, String>> specs, String buttonText) {
    return Expanded(
      child: Card(
        color: Colors.black87,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 12),
              ...specs.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("${s["label"]}: ${s["value"]}",
                        style: const TextStyle(color: Colors.white)),
                  )),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(buttonText,
                    style: const TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          const RedBar(),
          Column(
            children: [
              const LogoLayout(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Device & RFID
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSpecCard(
                              "Device Specifications",
                              [
                                {"label": "Device ID", "value": deviceId},
                                {"label": "COM Port", "value": selectedComPort},
                                {
                                  "label": "Baud Rate",
                                  "value": selectedBaudRate
                                },
                                {"label": "Company Code", "value": companyCode},
                                {
                                  "label": "API URL",
                                  "value": "https://www.api-url/endpoint"
                                },
                              ],
                              "DEVICE SETTINGS"),
                          buildSpecCard(
                              "RFID Specifications",
                              [
                                {"label": "COM Port", "value": rfidComPort},
                                {"label": "Baud Rate", "value": rfidBaudRate},
                                {"label": "Script Parameters", "value": "YES"},
                              ],
                              "RFID SETTINGS"),
                        ],
                      ),
                      // Machine specs
                      Card(
                        color: Colors.black87,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Machine Specifications",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 12),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: machines.length,
                                itemBuilder: (context, index) {
                                  final machine = machines[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      "Type: ${machine["type"]},"
                                          " Tag: ${machine["tag"]},"
                                          " Name: ${machine["name"]},"
                                          " Controller: ${machine["controller"]}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text("MACHINE SETTINGS",
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
