import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final alamatController = TextEditingController();

  bool pressed = false;

  late AnimationController controller;
  late Animation<Offset> slideAnim;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
    );

    fadeAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    controller.forward();
  }

  @override
  void dispose() {
    namaController.dispose();
    hpController.dispose();
    alamatController.dispose();
    controller.dispose();
    super.dispose();
  }

  /// ================= ELEGANT SNACKBAR =================
  void showElegantSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        duration: const Duration(milliseconds: 1600),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xCC1E1E1E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x66D4AF37)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFFD4AF37),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= REGISTER FUNCTION =================
  void handleRegister() {
    final nama = namaController.text.trim();
    final hp = hpController.text.trim();
    final alamat = alamatController.text.trim();

    /// ❌ EMPTY
    if (nama.isEmpty || hp.isEmpty || alamat.isEmpty) {
      showElegantSnackBar("Please fill in all fields");
      return;
    }

    /// ❌ PHONE INVALID
    if (hp.length < 10) {
      showElegantSnackBar("Invalid phone number");
      return;
    }

    /// ✅ SUCCESS
    showElegantSnackBar("Registration successful");

    debugPrint("=== REGISTER DATA ===");
    debugPrint("Nama    : $nama");
    debugPrint("No HP   : $hp");
    debugPrint("Alamat  : $alamat");
    debugPrint("=====================");

    /// DELAY BIAR USER LIAT NOTIFIKASI
    Future.delayed(const Duration(milliseconds: 900), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(
            nama: nama,
            hp: hp,
            alamat: alamat,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  /// ================= INPUT FIELD =================
  Widget inputField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0x22FFFFFF),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFFD4AF37),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: const Color(0x99000000),
            ),
          ),

          Center(
            child: SlideTransition(
              position: slideAnim,
              child: FadeTransition(
                opacity: fadeAnim,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: width * 0.85,
                      constraints: const BoxConstraints(maxWidth: 360),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22FFFFFF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0x44D4AF37),
                        ),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD4AF37),
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 25),

                          inputField(
                            "Full Name",
                            "Enter your full name",
                            namaController,
                          ),

                          const SizedBox(height: 16),

                          inputField(
                            "Phone Number",
                            "Enter your phone number",
                            hpController,
                          ),

                          const SizedBox(height: 16),

                          inputField(
                            "Full Address",
                            "Enter your full address",
                            alamatController,
                          ),

                          const SizedBox(height: 28),

                          GestureDetector(
                            onTapDown: (_) => setState(() => pressed = true),
                            onTapUp: (_) => setState(() => pressed = false),
                            onTapCancel: () =>
                                setState(() => pressed = false),
                            onTap: handleRegister,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              transformAlignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(pressed ? 0.97 : 1),
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD4AF37),
                                    Color(0xFFB8962E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
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
          ),
        ],
      ),
    );
  }
}