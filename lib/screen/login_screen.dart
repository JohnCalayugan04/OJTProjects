import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../Widgets/logolayout.dart';
import '../Widgets/background.dart';
import 'device_settings_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class AppConstants {
  static const String staticUsername = 'Testing101';
  static const String staticPassword = '101';
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final staticUsername = TextEditingController();
  final staticPassword = TextEditingController();
  final _company = TextEditingController();
  final String registerUrl = 'http://10.0.2.2:5072/api/auth/register';
  final String authUrl = 'http://10.0.2.2:5072/api/auth/login-face';
  bool _obscure = true;
  String? _errorText;

  final LocalAuthentication _auth = LocalAuthentication();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tryAutoBiometricLogin();
  }

  @override
  void dispose() {
    staticUsername.dispose();
    staticPassword.dispose();
    _company.dispose();
    super.dispose();
  }

  Future<void> _tryAutoBiometricLogin() async {
    bool canCheck = await _auth.canCheckBiometrics;
    bool isSupported = await _auth.isDeviceSupported();
    if (canCheck && isSupported) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      bool canCheck = await _auth.canCheckBiometrics;
      bool isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Biometric authentication not available")),
        );
        return;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        staticUsername.text = AppConstants.staticUsername;
        staticPassword.text = AppConstants.staticPassword;
        _onLogin();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Capture a face image
  Future<XFile?> _captureFace() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image;
  }

  // Send face image to backend to register
  Future<bool> _registerFace(XFile image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(registerUrl));
      request.fields['username'] = staticUsername.text.trim();
      request.fields['email'] = "${staticUsername.text.trim()}@test.com";
      request.fields['password'] = staticPassword.text.trim();
      request.files.add(await http.MultipartFile.fromPath(
          'face', image.path)); // <-- match backend param

      var response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Authenticate face with backend
  Future<bool> _authenticateWithFace(XFile image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:5072/api/auth/login-face'),
      );
      request.files.add(await http.MultipartFile.fromPath('face', image.path));

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResp = json.decode(respStr);
        // Successful login returns a token and user info
        print("Logged in as: ${jsonResp['user']['username']}");
        return true;
      } else {
        final jsonResp = json.decode(respStr);
        print(
            "Face login failed: ${jsonResp['error']} (Similarity: ${jsonResp['similarity'] ?? 'N/A'})");
        return false;
      }
    } catch (e) {
      print("Error calling login-face: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10 + bottomInset),
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
                      SizedBox(height: 5 * scaleFactor),
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
                                      Colors.grey[800]!.withValues(
                                          alpha: 0.08 + (0.02 * scaleFactor)),
                                      Colors.grey[700]!.withValues(
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
                                ),
                                padding: EdgeInsets.all(10 * scaleFactor),
                                child: Padding(
                                  padding: EdgeInsets.all(10 * scaleFactor),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildTextField(
                                          controller: staticUsername,
                                          hint: "Username",
                                          obscure: false,
                                          icon: Icons.person,
                                          scaleFactor: scaleFactor,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter username";
                                            } else if (value !=
                                                AppConstants.staticUsername) {
                                              return "Incorrect username";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 8 * scaleFactor),
                                        _buildTextField(
                                          controller: staticPassword,
                                          hint: "Password",
                                          obscure: _obscure,
                                          icon: Icons.lock,
                                          scaleFactor: scaleFactor,
                                          suffix: IconButton(
                                            onPressed: () => setState(
                                                () => _obscure = !_obscure),
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter password";
                                            } else if (value !=
                                                AppConstants.staticPassword) {
                                              return "Incorrect password";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 8 * scaleFactor),
                                        _buildTextField(
                                          controller: _company,
                                          hint: "Company Code",
                                          obscure: false,
                                          icon: Icons.business,
                                          scaleFactor: scaleFactor,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter company code";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 8 * scaleFactor),
                                        if (_errorText != null)
                                          Row(
                                            children: [
                                              const Icon(Icons.warning_amber,
                                                  color: Colors.yellow,
                                                  size: 18),
                                              const SizedBox(width: 6),
                                              Text(
                                                _errorText!,
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: 8 * scaleFactor),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 18),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: () {
                                              setState(() => _errorText = null);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _onLogin();
                                              }
                                            },
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
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16),
                                                child: const Text(
                                                  "Log In",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    letterSpacing: 1.2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              icon: const Icon(
                                                  Icons.fingerprint,
                                                  size: 28),
                                              label: const Text(
                                                  "Log in with Biometrics"),
                                              onPressed:
                                                  _authenticateWithBiometrics,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              icon: const Icon(Icons.face,
                                                  size: 28),
                                              label: const Text(
                                                  "Log in with Face"),
                                              onPressed: () async {
                                                if (_company.text.isEmpty) {
                                                  setState(() => _errorText =
                                                      "Please enter company code");
                                                  return;
                                                }
                                                XFile? image =
                                                    await _captureFace();
                                                if (image == null) return;
                                                bool match =
                                                    await _authenticateWithFace(
                                                        image);
                                                if (match) {
                                                  _onLogin();
                                                } else {
                                                  setState(() => _errorText =
                                                      "Face not recognized");
                                                }
                                              },
                                            ),
                                            OutlinedButton.icon(
                                              icon: const Icon(
                                                  Icons.add_a_photo,
                                                  size: 28),
                                              label:
                                                  const Text("Register Face"),
                                              onPressed: () async {
                                                if (_company.text.isEmpty ||
                                                    staticUsername
                                                        .text.isEmpty) {
                                                  setState(() => _errorText =
                                                      "Enter username and company code first");
                                                  return;
                                                }
                                                XFile? image =
                                                    await _captureFace();
                                                if (image == null) return;
                                                bool success =
                                                    await _registerFace(image);
                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Face registration successful"),
                                                    ),
                                                  );
                                                } else {
                                                  setState(() => _errorText =
                                                      "Face registration failed");
                                                }
                                              },
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
      style: const TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        suffixIcon: suffix,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10 * scaleFactor,
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

  void _onLogin() {
    if (staticUsername.text == AppConstants.staticUsername &&
        staticPassword.text == AppConstants.staticPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DeviceSettingsPage(companyCode: _company.text.trim()),
        ),
      );
    } else {
      setState(() {
        _errorText = "Invalid login credentials";
      });
    }
  }
}
