import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_screen.dart';

const goldColor = Color(0xFFD4AF37);
const darkBg = Color(0xFF120707);

class CartScreen extends StatefulWidget {
  final List<Map<String, String>> cartItems;
  final String nama;
  final String hp;
  final String alamat;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.nama,
    required this.hp,
    required this.alamat,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double getTotal() {
    double total = 0;

    for (var item in widget.cartItems) {
      String price = item["price"]!
          .replaceAll("IDR ", "")
          .replaceAll(".", "");

      total += double.tryParse(price) ?? 0;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Shopping Cart",
          style: GoogleFonts.playfairDisplay(
            color: goldColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [

          /// ================= BACKGROUND IMAGE =================
          Positioned.fill(
            child: Image.asset(
              "assets/assets/bg.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// ================= DARK OVERLAY =================
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.85),
            ),
          ),

          /// ================= CONTENT =================
          widget.cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 70,
                        color: goldColor,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Cart masih kosong",
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [

                    /// ================= LIST =================
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: widget.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.cartItems[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),

                              /// GLASS EFFECT
                              color: Colors.white.withOpacity(0.06),

                              border: Border.all(
                                color: goldColor.withOpacity(0.15),
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [

                                /// IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    "assets/assets/${item["image"]}",
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                /// TEXT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["title"]!,
                                        style:
                                            GoogleFonts.playfairDisplay(
                                          color: goldColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item["price"]!,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// DELETE BUTTON
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.cartItems.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.withOpacity(0.15),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    /// ================= TOTAL BOX =================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A0808),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        border: Border.all(
                          color: goldColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [

                          /// TOTAL
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Payment",
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "IDR ${getTotal().toStringAsFixed(0)}",
                                style:
                                    GoogleFonts.playfairDisplay(
                                  color: goldColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          /// BUTTON CHECKOUT
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),

                                /// GRADIENT BUTTON
                                backgroundColor: goldColor,
                              ),
                              onPressed: () {
                                final item =
                                    widget.cartItems.first;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrderScreen(
                                      image: item["image"]!,
                                      title: item["title"]!,
                                      price: item["price"]!,
                                      fullName:
                                          widget.nama,
                                      phone: widget.hp,
                                      address:
                                          widget.alamat,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Checkout Now",
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}