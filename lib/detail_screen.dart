import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_screen.dart';

const goldColor = Color(0xFFD4AF37);

class DetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String price;

  final String fullName;
  final String phone;
  final String address;

  const DetailScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _btnController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scale = Tween(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  void goToOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderScreen(
          image: widget.image,
          title: widget.title,
          price: widget.price,
          fullName: widget.fullName,
          phone: widget.phone,
          address: widget.address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildButton(),

      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/assets/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),

          /// SOFT BLUR
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          _circleBtn(
                            Icons.arrow_back_ios_new_rounded,
                            () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Product Details",
                                style: GoogleFonts.playfairDisplay(
                                  color: goldColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 36),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// IMAGE
                      Center(
                        child: Container(
                          width: width * 0.6,
                          constraints: const BoxConstraints(
                            maxWidth: 220,
                            maxHeight: 220,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.03),
                          ),
                          child: Hero(
                            tag: widget.image,
                            child: Image.asset(
                              "assets/assets/${widget.image}",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Luxury Flower Collection",
                        style: GoogleFonts.roboto(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// CARD
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 12, sigmaY: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.06),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: GoogleFonts.roboto(
                                    color: goldColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Elegant handcrafted flower arrangement with premium fresh flowers for special moments.",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      widget.price,
                                      style: GoogleFonts.roboto(
                                        color: goldColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BUTTON (FINAL REFINED)
  Widget _buildButton() {
    return GestureDetector(
      onTapDown: (_) => _btnController.forward(),
      onTapUp: (_) {
        _btnController.reverse();
        goToOrder();
      },
      onTapCancel: () => _btnController.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            gradient: LinearGradient(
              colors: [
                goldColor.withOpacity(0.95),
                goldColor.withOpacity(0.75),
              ],
            ),

            border: Border.all(
              color: goldColor.withOpacity(0.4),
            ),

            boxShadow: [
              BoxShadow(
                color: goldColor.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1A0F0F),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "MAKE ORDER",
                style: GoogleFonts.roboto(
                  color: const Color(0xFF1A0F0F),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.06),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}