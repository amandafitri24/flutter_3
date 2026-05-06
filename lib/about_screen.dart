import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const goldColor = Color(0xFFD4AF37);
const darkBg = Color(0xFF120707);

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// ================= GLASS CARD (SUBTLE) =================
  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: goldColor.withOpacity(0.12),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  /// ================= TEXT STYLE =================
  TextStyle titleStyle(bool isMobile) {
    return GoogleFonts.poppins(
      fontSize: isMobile ? 26 : 32,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }

  TextStyle bodyStyle() {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.white70,
      height: 1.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: darkBg,
      extendBodyBehindAppBar: true,

      /// ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: goldColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          /// ================= PARALLAX BG =================
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, scrollOffset * 0.25),
              child: Image.asset(
                "assets/assets/bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ================= DARK OVERLAY =================
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.85),
            ),
          ),

          /// ================= CONTENT =================
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: isMobile ? 100 : 120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// ================= LOGO =================
                    Hero(
                      tag: "logoHero",
                      child: Image.asset(
                        "assets/assets/logoA.png",
                        width: isMobile ? 80 : 100,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ================= TITLE =================
                    Text(
                      "Amanda Flower Shop",
                      textAlign: TextAlign.center,
                      style: titleStyle(isMobile).copyWith(
                        color: goldColor,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// ================= DESCRIPTION =================
                    glassCard(
                      child: Column(
                        children: [
                          Text(
                            "Founded in 2022, Amanda Flower Shop focuses on creating elegant and meaningful floral arrangements.",
                            textAlign: TextAlign.center,
                            style: bodyStyle(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Each bouquet is designed with a balance of modern aesthetics and natural beauty.",
                            textAlign: TextAlign.center,
                            style: bodyStyle(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "We believe flowers are a way to express emotions, celebrate moments, and build connections.",
                            textAlign: TextAlign.center,
                            style: bodyStyle(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// ================= QUOTE =================
                    Text(
                      "“Crafting beauty in every bouquet.”",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white60,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}