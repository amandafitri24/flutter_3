import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_screen.dart';

const goldColor = Color(0xFFD4AF37);

class CheckoutScreen extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final int qty;
  final String fullName;
  final String phone;
  final String address;

  const CheckoutScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.qty,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  /// ================= GET PRICE (FIX AMAN) =================
  int getPrice() {
    try {
      final clean = price.replaceAll(RegExp(r'[^0-9]'), '');
      return int.parse(clean);
    } catch (e) {
      return 0; // 🔥 biar tidak crash
    }
  }

  /// ================= FORMAT RUPIAH =================
  String formatRp(int number) {
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

    final bool isMobile = width < 700;

    /// 🔥 FIX: pastikan qty tidak 0
    final safeQty = qty <= 0 ? 1 : qty;

    int productPrice = getPrice() * safeQty;
    int discountProduct = 5000;
    int shipping = 6000;
    int discountShipping = 1000;

    int total =
        productPrice -
        discountProduct +
        shipping -
        discountShipping;

    return Scaffold(
      backgroundColor: const Color(0xFF120707),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 28,
            vertical: isMobile ? 16 : 24,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 720,
              ),

              child: Column(
                children: [
                  /// ================= HEADER =================
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Container(
                          padding: const EdgeInsets.all(11),

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: Colors.white.withOpacity(0.05),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),

                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: goldColor,
                            size: 18,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            "Checkout",

                            style: GoogleFonts.playfairDisplay(
                              color: goldColor,
                              fontSize:
                                  isMobile ? 24 : 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 42),
                    ],
                  ),

                  SizedBox(
                    height: isMobile ? 24 : 32,
                  ),

                  /// ================= MAIN CARD =================
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      isMobile ? 18 : 28,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),

                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2A0E0E),
                          Color(0xFF160707),
                        ],
                      ),

                      border: Border.all(
                        color: goldColor.withOpacity(0.18),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        /// ================= DELIVERY ADDRESS =================
                        Text(
                          "Delivery Address",

                          style: GoogleFonts.playfairDisplay(
                            color: goldColor,
                            fontSize:
                                isMobile ? 20 : 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(24),

                            color: Colors.white.withOpacity(
                              0.04,
                            ),

                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.06),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  color: goldColor
                                      .withOpacity(0.12),
                                ),

                                child: const Icon(
                                  Icons.location_on_outlined,
                                  color: goldColor,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      fullName.isEmpty
                                          ? "-"
                                          : fullName,

                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: isMobile
                                            ? 15
                                            : 16,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      phone.isEmpty
                                          ? "-"
                                          : phone,

                                      style: GoogleFonts.roboto(
                                        color:
                                            Colors.white70,
                                        fontSize:
                                            isMobile
                                                ? 12
                                                : 13,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      address.isEmpty
                                          ? "-"
                                          : address,

                                      style: GoogleFonts.roboto(
                                        color:
                                            Colors.white60,
                                        height: 1.6,
                                        fontSize:
                                            isMobile
                                                ? 12
                                                : 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: isMobile ? 28 : 34,
                        ),

                        /// ================= PRODUCT =================
                        Text(
                          "Product Order",

                          style: GoogleFonts.playfairDisplay(
                            color: goldColor,
                            fontSize:
                                isMobile ? 20 : 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(26),

                            color: Colors.white.withOpacity(
                              0.04,
                            ),

                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.06),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              Container(
                                width:
                                    isMobile ? 90 : 110,
                                height:
                                    isMobile ? 90 : 110,

                                padding:
                                    const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),

                                  color: Colors.white
                                      .withOpacity(0.04),
                                ),

                                child: Image.asset(
                                  "assets/assets/$image",
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error,
                                          stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white38,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      title,

                                      maxLines: 2,

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style: GoogleFonts
                                          .playfairDisplay(
                                        color: goldColor,
                                        fontSize:
                                            isMobile
                                                ? 18
                                                : 22,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      "${formatRp(getPrice())} x $safeQty",

                                      style:
                                          GoogleFonts.roboto(
                                        color:
                                            Colors.white70,
                                        fontSize:
                                            isMobile
                                                ? 13
                                                : 14,
                                        letterSpacing: 1,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),

                                        color: goldColor
                                            .withOpacity(
                                          0.12,
                                        ),
                                      ),

                                      child: Text(
                                        formatRp(
                                          productPrice,
                                        ),

                                        style:
                                            GoogleFonts.roboto(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              isMobile
                                                  ? 14
                                                  : 15,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: isMobile ? 28 : 36,
                        ),

                        /// ================= SUMMARY =================
                        Text(
                          "Payment Summary",

                          style: GoogleFonts.playfairDisplay(
                            color: goldColor,
                            fontSize:
                                isMobile ? 20 : 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(26),

                            color: Colors.white.withOpacity(
                              0.04,
                            ),

                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.06),
                            ),
                          ),

                          child: Column(
                            children: [
                              buildRow(
                                "Subtotal Product",
                                productPrice,
                              ),

                              buildRow(
                                "Product Discount",
                                -discountProduct,
                              ),

                              buildRow(
                                "Shipping Fee",
                                shipping,
                              ),

                              buildRow(
                                "Shipping Discount",
                                -discountShipping,
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),

                                child: Divider(
                                  color: Colors.white
                                      .withOpacity(0.10),
                                  thickness: 1,
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,

                                children: [
                                  Text(
                                    "Total Payment",

                                    style:
                                        GoogleFonts.roboto(
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

                                  Flexible(
                                    child: Text(
                                      formatRp(total),

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      textAlign:
                                          TextAlign.end,

                                      style:
                                          GoogleFonts.roboto(
                                        color:
                                            goldColor,
                                        fontSize:
                                            isMobile
                                                ? 24
                                                : 30,
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

                        SizedBox(
                          height: isMobile ? 30 : 38,
                        ),

                        /// ================= BUTTON =================
                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  goldColor,

                              elevation: 0,

                              padding:
                                  EdgeInsets.symmetric(
                                vertical:
                                    isMobile
                                        ? 18
                                        : 20,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),
                              ),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          PaymentScreen(
                                            image:
                                                image,
                                            title:
                                                title,
                                            price:
                                                price,
                                            qty:
                                                safeQty,
                                            fullName:
                                                fullName,
                                            phone:
                                                phone,
                                            address:
                                                address,
                                          ),
                                ),
                              );
                            },

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

                              children: [
                                const Icon(
                                  Icons.payment_rounded,
                                  color:
                                      Color(0xFF120707),
                                  size: 22,
                                ),

                                const SizedBox(width: 12),

                                Text(
                                  "CHOOSE PAYMENT METHOD",

                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      GoogleFonts.roboto(
                                    color:
                                        const Color(
                                      0xFF120707,
                                    ),
                                    fontSize:
                                        isMobile
                                            ? 14
                                            : 15,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    letterSpacing:
                                        1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: isMobile ? 20 : 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= ROW =================
  Widget buildRow(
    String title,
    int value,
  ) {
    bool isMinus = value < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Text(
              title,

              style: GoogleFonts.roboto(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Text(
              isMinus
                  ? "- ${formatRp(value.abs())}"
                  : formatRp(value),

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.end,

              style: GoogleFonts.roboto(
                color: isMinus
                    ? Colors.redAccent.shade100
                    : Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}