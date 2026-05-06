import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

const goldColor = Color(0xFFD4AF37);

class ReceiptScreen extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final int qty;
  final String paymentMethod;

  final String fullName;
  final String phone;
  final String address;

  const ReceiptScreen({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.qty,
    required this.paymentMethod,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  int getPrice() {
    return int.tryParse(
          price.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
  }

  int get shippingFee => 10000;

  int get total =>
      (getPrice() * qty) + shippingFee;

  bool get isCOD =>
      paymentMethod.toUpperCase() == "COD";

  String get paymentStatus =>
      isCOD ? "PAY ON DELIVERY" : "PAID";

  String formatPrice(int value) {
    String text = value.toString();

    String result = '';

    int count = 0;

    for (int i = text.length - 1;
        i >= 0;
        i--) {
      count++;

      result = text[i] + result;

      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }

    return "IDR $result";
  }

  String getInvoiceNumber() {
    final now = DateTime.now();

    return "INV-${now.year}${now.month}${now.day}-${now.hour}${now.minute}${now.second}";
  }

  String getDateNow() {
    final now = DateTime.now();

    return "${now.day}/${now.month}/${now.year}";
  }

  Widget buildRow(
    String title,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: isTotal
                    ? Colors.white
                    : Colors.white70,
                fontSize: 13,
                fontWeight: isTotal
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.visible,
              style: GoogleFonts.roboto(
                color:
                    isTotal ? goldColor : Colors.white,
                fontSize: isTotal ? 16 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isCOD
            ? Colors.orange.withOpacity(0.08)
            : goldColor.withOpacity(0.08),
        border: Border.all(
          color: isCOD
              ? Colors.orange.withOpacity(0.4)
              : goldColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCOD
                  ? Colors.orange.withOpacity(0.15)
                  : goldColor.withOpacity(0.15),
            ),
            child: Icon(
              isCOD
                  ? Icons.local_shipping_outlined
                  : Icons.verified_rounded,
              color:
                  isCOD ? Colors.orange : goldColor,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isCOD
                      ? "COD Payment Pending"
                      : "Payment Completed",
                  style: GoogleFonts.playfairDisplay(
                    color: isCOD
                        ? Colors.orange
                        : goldColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  isCOD
                      ? "Please prepare the payment when your flower order arrives at your address."
                      : "Your payment has been successfully completed and verified.",
                  style: GoogleFonts.roboto(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final isMobile = width < 700;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF120A0A),

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            "Payment Receipt",
            style:
                GoogleFonts.playfairDisplay(
              color: goldColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 700,
            ),

            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 14,
              ),

              child: Column(
                children: [
                  /// ================= SUCCESS ICON =================
                  Container(
                    padding:
                        const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          goldColor.withOpacity(
                        0.12,
                      ),

                      border: Border.all(
                        color: goldColor
                            .withOpacity(0.3),
                      ),
                    ),

                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: goldColor,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    isCOD
                        ? "Order Successfully Created"
                        : "Payment Successfully Completed",
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.playfairDisplay(
                      color: goldColor,
                      fontSize:
                          isMobile ? 28 : 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    isCOD
                        ? "Your flower order has been confirmed with Cash On Delivery payment."
                        : "Thank you for ordering premium flowers from Amanda Flower Shop.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= STATUS CARD =================
                  statusCard(),

                  const SizedBox(height: 24),

                  /// ================= RECEIPT CARD =================
                  Container(
                    width: double.infinity,

                    padding: EdgeInsets.all(
                      isMobile ? 18 : 24,
                    ),

                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                        28,
                      ),

                      color: Colors.white
                          .withOpacity(0.05),

                      border: Border.all(
                        color: goldColor
                            .withOpacity(0.15),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.28),
                          blurRadius: 18,
                          offset:
                              const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        /// HEADER
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(14),

                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  18,
                                ),

                                color: goldColor
                                    .withOpacity(
                                  0.12,
                                ),
                              ),

                              child: const Icon(
                                Icons
                                    .receipt_long,
                                color: goldColor,
                                size: 28,
                              ),
                            ),

                            const SizedBox(
                                width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  Text(
                                    "Amanda Flower Shop",

                                    style: GoogleFonts
                                        .playfairDisplay(
                                      color:
                                          goldColor,
                                      fontSize:
                                          isMobile
                                              ? 22
                                              : 26,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    "Luxury Flower Arrangement",

                                    style:
                                        GoogleFonts
                                            .roboto(
                                      color: Colors
                                          .white60,
                                      fontSize:
                                          11,
                                      letterSpacing:
                                          1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.white12,
                        ),

                        const SizedBox(height: 22),

                        /// INVOICE
                        buildRow(
                          "Invoice Number",
                          getInvoiceNumber(),
                        ),

                        buildRow(
                          "Transaction Date",
                          getDateNow(),
                        ),

                        buildRow(
                          "Payment Method",
                          paymentMethod,
                        ),

                        buildRow(
                          "Payment Status",
                          paymentStatus,
                        ),

                        const SizedBox(height: 20),

                        /// CUSTOMER
                        Text(
                          "Customer Information",

                          style: GoogleFonts
                              .playfairDisplay(
                            color: goldColor,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),

                            color: Colors.white
                                .withOpacity(
                              0.04,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              Text(
                                fullName,

                                style: GoogleFonts
                                    .roboto(
                                  color: Colors
                                      .white,
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(
                                phone,

                                style: GoogleFonts
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
                                address,

                                style: GoogleFonts
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

                        const SizedBox(height: 24),

                        /// PRODUCT
                        Text(
                          "Order Details",

                          style: GoogleFonts
                              .playfairDisplay(
                            color: goldColor,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Container(
                              width: isMobile
                                  ? 90
                                  : 110,
                              height: isMobile
                                  ? 90
                                  : 110,

                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  22,
                                ),

                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.04,
                                ),

                                border:
                                    Border.all(
                                  color:
                                      goldColor
                                          .withOpacity(
                                    0.15,
                                  ),
                                ),
                              ),

                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  22,
                                ),

                                child: Image.asset(
                                  "assets/assets/$image",
                                  fit:
                                      BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(
                                width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  Text(
                                    title,

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
                                    "Quantity : $qty",

                                    style:
                                        GoogleFonts
                                            .roboto(
                                      color: Colors
                                          .white70,
                                      fontSize:
                                          12,
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
                                      color: Colors
                                          .white,
                                      fontSize:
                                          14,
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

                        const SizedBox(height: 26),

                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.white12,
                        ),

                        const SizedBox(height: 20),

                        /// SUMMARY
                        Text(
                          "Payment Summary",

                          style: GoogleFonts
                              .playfairDisplay(
                            color: goldColor,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 14),

                        buildRow(
                          "Flower Subtotal",
                          formatPrice(
                            getPrice() * qty,
                          ),
                        ),

                        buildRow(
                          "Shipping Fee",
                          formatPrice(
                              shippingFee),
                        ),

                        const Padding(
                          padding:
                              EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          child: Divider(
                            color:
                                Colors.white12,
                            thickness: 1,
                          ),
                        ),

                        buildRow(
                          "Total Payment",
                          formatPrice(total),
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// ================= BUTTON =================
                  SizedBox(
                    width: double.infinity,

                    child:
                        ElevatedButton.icon(
                      style:
                          ElevatedButton
                              .styleFrom(
                        elevation: 0,
                        backgroundColor:
                            goldColor,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 17,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),
                        ),
                      ),

                      onPressed: () {
                        Navigator
                            .pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                HomeScreen(
                              nama: fullName,
                              hp: phone,
                              alamat: address,
                            ),
                          ),
                          (route) => false,
                        );
                      },

                      icon: const Icon(
                        Icons.home_rounded,
                        color:
                            Color(0xFF1A0F0F),
                      ),

                      label: Text(
                        "BACK TO HOME",

                        style:
                            GoogleFonts.roboto(
                          color: const Color(
                              0xFF1A0F0F),
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