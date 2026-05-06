import 'dart:ui';
import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
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
      begin: const Offset(0, -0.3),
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
    emailController.dispose();
    passwordController.dispose();
    controller.dispose();
    super.dispose();
  }

  /// ================= PREMIUM SNACKBAR =================
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xCC1E1E1E), // dark glass
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

  /// ================= LOGIN FUNCTION =================
  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    /// ❌ EMPTY
    if (email.isEmpty || password.isEmpty) {
      showElegantSnackBar("Please fill in all fields");
      return;
    }

    /// ❌ INVALID EMAIL
    if (!email.contains("@")) {
      showElegantSnackBar("Invalid email format");
      return;
    }

    /// ✅ SUCCESS
    showElegantSnackBar("Login successful");

    debugPrint("=== LOGIN DATA ===");
    debugPrint("Email    : $email");
    debugPrint("Password : $password");
    debugPrint("==================");

    Future.delayed(const Duration(milliseconds: 900), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RegisterScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
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
                        horizontal: 26,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22FFFFFF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0x44D4AF37),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 25,
                            offset: Offset(0, 12),
                          )
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Login Amanda Flower Shop",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD4AF37),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Center(
                            child: Text(
                              "Login to continue",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle:
                                  const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0x22FFFFFF),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD4AF37),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: passwordController,
                            obscureText: hidePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle:
                                  const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: const Color(0x22FFFFFF),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD4AF37),
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          GestureDetector(
                            onTapDown: (_) => setState(() => pressed = true),
                            onTapUp: (_) => setState(() => pressed = false),
                            onTapCancel: () =>
                                setState(() => pressed = false),
                            onTap: handleLogin,
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
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x55D4AF37),
                                    blurRadius: 18,
                                    offset: Offset(0, 6),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  "SIGN IN",
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