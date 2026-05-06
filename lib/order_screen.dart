import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';

const goldColor = Color(0xFFD4AF37);

class OrderScreen extends StatefulWidget {
  final String image;
  final String title;
  final String price;

  final String fullName;
  final String phone;
  final String address;

  const OrderScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  int qty = 1;

  late AnimationController _pageController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late AnimationController _btnController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _pageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(_pageController);

    _slide = Tween(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageController,
      curve: Curves.easeOutCubic,
    ));

    _pageController.forward();

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
    _pageController.dispose();
    _btnController.dispose();
    super.dispose();
  }

  int getPrice() {
    return int.tryParse(
          widget.price.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
  }

  int get total => qty * getPrice();

  String formatRupiah(int number) {
    String value = number.toString();
    String result = '';
    int count = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      count++;
      result = value[i] + result;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return "Rp $result";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Stack(
            children: [
              /// BACKGROUND
              Positioned.fill(
                child: Image.asset(
                  "assets/assets/bg.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              /// DARK LAYER
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.65),
                ),
              ),

              /// BLUR
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(color: Colors.transparent),
                ),
              ),

              /// GLOW
              Positioned(top: -60, left: -40, child: _glow(160)),
              Positioned(bottom: -80, right: -50, child: _glow(200)),

              /// CONTENT
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: height, // 🔥 FULL HEIGHT
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: 16,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            children: [
                              /// HEADER
                              Row(
                                children: [
                                  _circleBtn(() => Navigator.pop(context)),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Order Flower",
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

                              const SizedBox(height: 22),

                              /// CARD
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 14, sigmaY: 14),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.04),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.06),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxHeight: 160),
                                          child: Hero(
                                            tag: widget.image,
                                            child: Image.asset(
                                              "assets/assets/${widget.image}",
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 14),

                                        Text(
                                          widget.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.playfairDisplay(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          formatRupiah(getPrice()),
                                          style: GoogleFonts.roboto(
                                            color: goldColor,
                                            fontSize: 15,
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        /// QTY
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color:
                                                Colors.white.withOpacity(0.05),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Quantity",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  _qtyBtn(Icons.remove, () {
                                                    if (qty > 1) {
                                                      setState(() => qty--);
                                                    }
                                                  }),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    "$qty",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  _qtyBtn(Icons.add, () {
                                                    setState(() => qty++);
                                                  }, isPrimary: true),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 18),

                                        /// TOTAL
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                              color:
                                                  goldColor.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Total Payment",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white60,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                formatRupiah(total),
                                                style: GoogleFonts.roboto(
                                                  color: goldColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 22),

                                        /// BUTTON
                                        GestureDetector(
                                          onTapDown: (_) =>
                                              _btnController.forward(),
                                          onTapUp: (_) {
                                            _btnController.reverse();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => CheckoutScreen(
                                                  image: widget.image,
                                                  title: widget.title,
                                                  price: widget.price,
                                                  qty: qty,
                                                  fullName: widget.fullName,
                                                  phone: widget.phone,
                                                  address: widget.address,
                                                ),
                                              ),
                                            );
                                          },
                                          onTapCancel: () =>
                                              _btnController.reverse(),
                                          child: ScaleTransition(
                                            scale: _scale,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    goldColor.withOpacity(0.95),
                                                    goldColor.withOpacity(0.75),
                                                  ],
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.shopping_bag_outlined,
                                                    color: Color(0xFF120707),
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "PLACE ORDER",
                                                    style:
                                                        GoogleFonts.roboto(
                                                      color:
                                                          const Color(0xFF120707),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// 🔥 PENTING: isi bawah biar tidak putih
                              const SizedBox(height: 120),
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
        ),
      ),
    );
  }

  Widget _circleBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.06),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: goldColor,
          size: 16,
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap,
      {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary
              ? goldColor
              : Colors.white.withOpacity(0.08),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isPrimary
              ? const Color(0xFF120707)
              : goldColor,
        ),
      ),
    );
  }

  Widget _glow(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            goldColor.withOpacity(0.12),
            Colors.transparent
          ],
        ),
      ),
    );
  }
}