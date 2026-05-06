import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'receipt_screen.dart';

const goldColor = Color(0xFFD4AF37);

class PaymentScreen extends StatefulWidget {
  final String image;
  final String title;
  final String price;
  final int qty;

  final String fullName;
  final String phone;
  final String address;

  const PaymentScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.qty,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  String selectedMethod = "COD";

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  int getPrice() {
    return int.tryParse(
          widget.price.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
  }

  String formatPrice(int value) {
    String number = value.toString();
    String result = "";

    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      count++;
      result = number[i] + result;

      if (count % 3 == 0 && i != 0) {
        result = ".$result";
      }
    }

    return "IDR $result";
  }

  int get shippingFee => 10000;

  int get totalPrice =>
      (getPrice() * widget.qty) + shippingFee;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget infoCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1111),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: goldColor.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget paymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    final bool isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isSelected
              ? goldColor.withOpacity(0.10)
              : Colors.white.withOpacity(0.03),
          border: Border.all(
            color: isSelected
                ? goldColor
                : Colors.white.withOpacity(0.06),
            width: 1.2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: goldColor.withOpacity(0.15),
                blurRadius: 18,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? goldColor.withOpacity(0.14)
                    : Colors.white.withOpacity(0.04),
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? goldColor : Colors.white70,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? goldColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? goldColor
                      : Colors.white38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Color(0xFF1A0F0F),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(width: 10),

        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration:
                const Duration(milliseconds: 350),
            tween: Tween(begin: 0.8, end: 1),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1111),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: goldColor.withOpacity(0.22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: goldColor.withOpacity(0.18),
                    blurRadius: 30,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goldColor,
                      boxShadow: [
                        BoxShadow(
                          color:
                              goldColor.withOpacity(0.45),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 34,
                      color: Color(0xFF1A0F0F),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    "Payment Successful",
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.playfairDisplay(
                      color: goldColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Your flower order has been successfully confirmed and is currently being prepared.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(18),
                      color:
                          Colors.white.withOpacity(0.03),
                    ),
                    child: Column(
                      children: [
                        buildSummaryRow(
                          "Payment Method",
                          selectedMethod,
                        ),

                        const SizedBox(height: 10),

                        buildSummaryRow(
                          "Total Payment",
                          formatPrice(totalPrice),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReceiptScreen(
                              image: widget.image,
                              title: widget.title,
                              price: widget.price,
                              qty: widget.qty,
                              paymentMethod:
                                  selectedMethod,
                              fullName:
                                  widget.fullName,
                              phone: widget.phone,
                              address:
                                  widget.address,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "VIEW RECEIPT",
                        style: GoogleFonts.roboto(
                          color:
                              const Color(0xFF1A0F0F),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final bool isMobile = width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF120A0A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        iconTheme:
            const IconThemeData(color: goldColor),

        title: Text(
          "Payment",
          style: GoogleFonts.playfairDisplay(
            color: goldColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 700,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 12,
              ),
              child: Column(
                children: [
                  /// SHIPPING ADDRESS
                  infoCard(
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(14),
                          decoration:
                              BoxDecoration(
                            shape: BoxShape.circle,
                            color: goldColor
                                .withOpacity(0.12),
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: goldColor,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                "Shipping Address",
                                style: GoogleFonts
                                    .playfairDisplay(
                                  color: goldColor,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                widget.fullName,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color:
                                      Colors.white,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                widget.phone,
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color: Colors
                                      .white60,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(
                                widget.address,
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color: Colors
                                      .white70,
                                  fontSize: 12,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// PRODUCT
                  infoCard(
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width:
                              isMobile ? 95 : 120,
                          height:
                              isMobile ? 95 : 120,
                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius
                                    .circular(22),
                            color: Colors.white
                                .withOpacity(0.03),
                            border: Border.all(
                              color: goldColor
                                  .withOpacity(0.15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(22),
                            child: Image.asset(
                              "assets/assets/${widget.image}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style: GoogleFonts
                                    .playfairDisplay(
                                  color:
                                      goldColor,
                                  fontSize:
                                      isMobile
                                          ? 18
                                          : 22,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                "Quantity : ${widget.qty}",
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color: Colors
                                      .white70,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                formatPrice(
                                  getPrice(),
                                ),
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      isMobile
                                          ? 15
                                          : 16,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// PAYMENT METHOD
                  infoCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Method",
                          style: GoogleFonts
                              .playfairDisplay(
                            color: goldColor,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        paymentOption(
                          icon: Icons.payments,
                          title:
                              "Cash On Delivery",
                          subtitle:
                              "Pay directly when flowers arrive",
                          value: "COD",
                        ),

                        paymentOption(
                          icon: Icons.account_balance_wallet,
                          title: "DANA",
                          subtitle:
                              "Fast digital wallet payment",
                          value: "DANA",
                        ),

                        paymentOption(
                          icon: Icons.wallet,
                          title: "OVO",
                          subtitle:
                              "Easy mobile checkout payment",
                          value: "OVO",
                        ),
                      ],
                    ),
                  ),

                  /// TOTAL
                  infoCard(
                    child: Column(
                      children: [
                        buildSummaryRow(
                          "Flower Price",
                          formatPrice(
                            getPrice() *
                                widget.qty,
                          ),
                        ),

                        const SizedBox(height: 10),

                        buildSummaryRow(
                          "Shipping Fee",
                          formatPrice(
                            shippingFee,
                          ),
                        ),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: Divider(
                            color: Colors.white12,
                          ),
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Text(
                              "Total Payment",
                              style: GoogleFonts
                                  .playfairDisplay(
                                color:
                                    Colors.white,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            Flexible(
                              child: Text(
                                formatPrice(
                                  totalPrice,
                                ),
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                textAlign:
                                    TextAlign.end,
                                style:
                                    GoogleFonts
                                        .roboto(
                                  color:
                                      goldColor,
                                  fontSize:
                                      isMobile
                                          ? 19
                                          : 22,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            goldColor,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                        ),
                      ),
                      onPressed:
                          showSuccessDialog,
                      icon: const Icon(
                        Icons.lock_outline,
                        color:
                            Color(0xFF1A0F0F),
                      ),
                      label: Text(
                        "CONFIRM PAYMENT",
                        style: GoogleFonts.roboto(
                          color:
                              const Color(0xFF1A0F0F),
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}