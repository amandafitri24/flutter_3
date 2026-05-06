import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {
  /// FLOAT LOGO
  late AnimationController floatController;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  /// CURSOR FADE
  late AnimationController cursorController;

  /// TYPING
  final String fullText = "Amanda Flower Shop";
  String displayedText = "";
  int index = 0;
  bool isDeleting = false;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();

    /// FLOAT ANIMATION
    floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    fadeAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    /// CURSOR SMOOTH FADE
    cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);

    /// START TYPING
    startTyping();
  }

  void startTyping() {
    typingTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      setState(() {
        if (!isDeleting) {
          /// MENGETIK (LEBIH PELAN)
          if (index < fullText.length) {
            displayedText = fullText.substring(0, index + 1);
            index++;
          } else {
            /// PAUSE SAAT FULL
            Future.delayed(const Duration(milliseconds: 1200), () {
              isDeleting = true;
            });
          }
        } else {
          /// MENGHAPUS (LEBIH CEPAT DIKIT)
          if (index > 0) {
            displayedText = fullText.substring(0, index - 1);
            index--;
          } else {
            /// PAUSE SAAT KOSONG
            Future.delayed(const Duration(milliseconds: 600), () {
              isDeleting = false;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    floatController.dispose();
    cursorController.dispose();
    typingTimer?.cancel();
    super.dispose();
  }

  void goToLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),

          /// OVERLAY
          Positioned.fill(
            child: Container(
              color: const Color(0x99000000),
            ),
          ),

          /// CONTENT
          Center(
            child: GestureDetector(
              onTap: goToLogin,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// LOGO FLOATING
                  FadeTransition(
                    opacity: fadeAnim,
                    child: ScaleTransition(
                      scale: scaleAnim,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Color(0x33D4AF37),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/logoA.png',
                            width: 110,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// TITLE + CURSOR
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayedText,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      FadeTransition(
                        opacity: cursorController,
                        child: const Text(
                          "|",
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Elegant Flowers • Premium Quality",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0x66D4AF37),
                      ),
                      color: const Color(0x22D4AF37),
                    ),
                    child: const Text(
                      "Tap to continue",
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}