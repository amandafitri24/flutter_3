import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_screen.dart';
import 'cart_screen.dart';
import 'about_screen.dart';

/// ================= GLOBAL STYLE =================
const goldColor = Color(0xFFD4AF37);

/// WARNA
const darkBg = Color(0xFF120707);
const darkRed = Color(0xFF1A0808);

/// HEADER
const headerGrad1 = Color(0xFF220404);
const headerGrad2 = Color(0xFF110202);

class HomeScreen extends StatefulWidget {
  final String nama;
  final String hp;
  final String alamat;

  const HomeScreen({
    super.key,
    required this.nama,
    required this.hp,
    required this.alamat,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController =
      TextEditingController();

  String searchText = "";

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey productKey = GlobalKey();
  final GlobalKey cartKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int selectedNav = 0;

  final List<Map<String, String>> cartItems = [];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    _fadeController.forward();
  }

  /// ================= NAVIGATION SCROLL =================
  void scrollToSection(GlobalKey key, int index) {
    setState(() {
      selectedNav = index;
    });

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  /// ================= ADD CART =================
  void addToCart(
    String image,
    String title,
    String price,
  ) {
    setState(() {
      cartItems.add({
        "image": image,
        "title": title,
        "price": price,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1B0909),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text(
          "$title added to cart",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  /// ================= GREETING =================
  String getGreeting() {
    final now = DateTime.now().toUtc().add(
      const Duration(hours: 7),
    );

    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Night";
    }
  }

  int getGridCount(double width) {
    if (width < 600) return 2;
    if (width < 1000) return 4;
    return 6;
  }

  /// ================= OPEN MAP =================
  Future<void> openMap() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=Senayan+Jakarta+Selatan",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

Future<void> openUrl(String link) async {
  final Uri url = Uri.parse(link);

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw "Tidak bisa membuka $link";
  }
}

  List<List<String>> getFilteredFlowers(
    List<List<String>> data,
  ) {
    if (searchText.isEmpty) return data;

    return data.where((flower) {
      return flower[1]
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 700;

    final crossAxisCount = getGridCount(width);

    final filteredSittingFlowers =
        getFilteredFlowers(sittingFlowers);

    final filteredBestFlowers =
        getFilteredFlowers(bestFlowers);

return Scaffold(
  backgroundColor: darkBg,

  bottomNavigationBar: Container(
    margin: const EdgeInsets.all(12),
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: const Color(0xFF1A0808),
      borderRadius: BorderRadius.circular(35),
      border: Border.all(
        color: goldColor.withOpacity(0.25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        navItem(
          icon: Icons.home_rounded,
          text: "Home",
          index: 0,
          onTap: () => scrollToSection(homeKey, 0),
        ),

        navItem(
          icon: Icons.local_florist,
          text: "Menu",
          index: 1,
          onTap: () => scrollToSection(productKey, 1),
        ),

        navItem(
          icon: Icons.shopping_cart,
          text: "Cart",
          index: 2,
          badge: cartItems.length,
          onTap: () {
        Navigator.push(
          context,
        MaterialPageRoute(
          builder: (_) => CartScreen(
          cartItems: cartItems,
          nama: widget.nama,
          hp: widget.hp,
          alamat: widget.alamat,
         ),
      ),
    );
  },
),

navItem(
  icon: Icons.info_outline,
  text: "About",
  index: 3,
  onTap: () {
    setState(() {
      selectedNav = 3;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutScreen(),
      ),
    );
  },
),      ],
    ),
  ),

      body: FadeTransition(
        opacity: _fadeAnimation,

        child: Column(
          children: [
            /// ================= HEADER =================
            Container(
              width: double.infinity,

              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 22,
                vertical: isMobile ? 6 : 8,
              ),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    headerGrad1.withOpacity(0.96),
                    headerGrad2.withOpacity(0.94),
                  ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: SafeArea(
                bottom: false,

                child: Column(
                  children: [
                    /// ================= TOP HEADER =================
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        /// ================= LEFT =================
                        Expanded(
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/assets/logoA.png",
                                width:
                                    isMobile ? 30 : 38,
                                height:
                                    isMobile ? 30 : 38,
                                fit: BoxFit.contain,

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Icon(
                                    Icons.local_florist,
                                    color: goldColor,
                                    size: isMobile
                                        ? 20
                                        : 24,
                                  );
                                },
                              ),

                              SizedBox(
                                width:
                                    isMobile ? 8 : 10,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,

                                  children: [
                                    Text(
                                      "Amanda Flower Shop",

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          GoogleFonts
                                              .roboto(
                                        color:
                                            goldColor,
                                        fontSize:
                                            isMobile
                                                ? 12
                                                : 15,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                        letterSpacing:
                                            2,
                                      ),
                                    ),

                                    Text(
                                      "Luxury Flower Arrangement",

                                      overflow:
                                          TextOverflow
                                              .ellipsis,

                                      style:
                                          GoogleFonts
                                              .roboto(
                                        color: Colors
                                            .white60,
                                        fontSize:
                                            isMobile
                                                ? 7
                                                : 9,
                                        letterSpacing:
                                            1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          width: isMobile ? 8 : 12,
                        ),

                        /// ================= RIGHT =================
                        Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                isMobile ? 145 : 210,
                          ),

                          padding:
                              EdgeInsets.symmetric(
                            horizontal:
                                isMobile ? 10 : 12,
                            vertical:
                                isMobile ? 6 : 8,
                          ),

                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),

                            color: Colors.white
                                .withOpacity(0.05),

                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.05),
                            ),
                          ),

                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,

                            children: [
                              Icon(
                                Icons
                                    .waving_hand_rounded,
                                color: goldColor,
                                size: isMobile
                                    ? 13
                                    : 15,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Expanded(
                                child: Text(
                                  "${getGreeting()}, ${widget.nama}",

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      GoogleFonts
                                          .roboto(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        isMobile
                                            ? 8.5
                                            : 10,
                                    letterSpacing:
                                        1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                              ],
                ),
              ),
            ),

            /// ================= CONTENT =================
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  /// ================= HERO =================
                  SizedBox(
                    key: homeKey,
                    height: isMobile ? 300 : 420,

                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            "assets/assets/atas_mawar.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned.fill(
                          child: Container(
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                begin: Alignment
                                    .topCenter,
                                end: Alignment
                                    .bottomCenter,
                                colors: [
                                  Colors.black
                                      .withOpacity(
                                    0.45,
                                  ),
                                  Colors.black
                                      .withOpacity(
                                    0.88,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 20,
                            ),

                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

                              children: [
                                Text(
                                  "Amanda Flower Shop",

                                  textAlign:
                                      TextAlign
                                          .center,

                                  style:
                                      GoogleFonts
                                          .greatVibes(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        isMobile
                                            ? 42
                                            : 68,
                                  ),
                                ),

                                const SizedBox(
                                  height: 12,
                                ),

                                Text(
                                  "Elegant Flowers • Premium Quality",

                                  textAlign:
                                      TextAlign
                                          .center,

                                  style:
                                      GoogleFonts
                                          .playfairDisplay(
                                    color: Colors
                                        .white70,
                                    fontSize:
                                        isMobile
                                            ? 12
                                            : 16,
                                    letterSpacing:
                                        1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ================= SITTING FLOWER =================
                  sectionBackground(
                    child: Padding(
                      key: productKey,
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      child: Column(
                        children: [
                          /// SEARCH
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                            ),

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),

                              color: Colors.white
                                  .withOpacity(
                                0.08,
                              ),

                              border: Border.all(
                                color: goldColor
                                    .withOpacity(
                                  0.2,
                                ),
                              ),
                            ),

                            child: TextField(
                              controller:
                                  _searchController,

                              onChanged: (value) {
                                setState(() {
                                  searchText =
                                      value;
                                });
                              },

                              style:
                                  GoogleFonts
                                      .roboto(
                                color:
                                    Colors.white,
                                fontSize: 13,
                              ),

                              decoration:
                                  InputDecoration(
                                border:
                                    InputBorder
                                        .none,

                                icon: Icon(
                                  Icons.search,
                                  color:
                                      goldColor,
                                  size: 22,
                                ),

                                hintText:
                                    "Search flowers...",

                                hintStyle:
                                    GoogleFonts
                                        .roboto(
                                  color: Colors
                                      .white54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          sectionTitle(
                            "Sitting Flower",
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          buildGrid(
                            crossAxisCount,
                            filteredSittingFlowers,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= BEST FLOWER =================
                  sectionBackground(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        18,
                      ),

                      child: Column(
                        children: [
                          sectionTitle(
                            "Best Flower",
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          buildGrid(
                            crossAxisCount,
                            filteredBestFlowers,
                          ),
                        ],
                      ),
                    ),
                  ),


/// ================= FOOTER PREMIUM =================
Container(
  key: contactKey,
  padding: const EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 40,
  ),
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF130606),
        Color(0xFF090202),
      ],
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      /// LOGO
      Image.asset(
        "assets/assets/logoA.png",
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),

      const SizedBox(height: 16),

      /// BRAND
      Text(
        "Amanda Flower Shop",
        textAlign: TextAlign.center,
        style: GoogleFonts.greatVibes(
          color: goldColor,
          fontSize: 36,
        ),
      ),

      const SizedBox(height: 6),

      /// SLOGAN
      Text(
        "Elegant • Luxury • Premium Flowers",
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(
          color: Colors.white70,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),

      const SizedBox(height: 28),

      /// DIVIDER
      Container(
        width: 120,
        height: 1,
        color: goldColor.withOpacity(0.3),
      ),

      const SizedBox(height: 24),

      /// CONTACT
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: goldColor, size: 16),
              const SizedBox(width: 8),
              Text(
                "085977554411",
                style: GoogleFonts.roboto(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: goldColor, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Alamat Anda Disini, Kota, Indonesia",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 28),

/// SOCIAL (UPDATED)
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    /// INSTAGRAM
    GestureDetector(
      onTap: () {
        openUrl("https://instagram.com/amanda_flowershop");
      },
      child: socialIcon(Icons.camera_alt),
    ),

    const SizedBox(width: 14),

    /// TIKTOK
    GestureDetector(
      onTap: () {
        openUrl("https://www.tiktok.com/@amanda_flowershop");
      },
      child: socialIcon(Icons.music_note),
    ),

    const SizedBox(width: 14),

    /// GOOGLE MAPS (PLAZA SENAYAN)
    GestureDetector(
      onTap: () {
        openUrl(
          "https://www.google.com/maps/search/?api=1&query=Plaza+Senayan+Jakarta",
        );
      },
      child: socialIcon(Icons.location_on),
    ),
  ],
),

const SizedBox(height: 12),

Text(
  "@amanda_flowershop",
  style: GoogleFonts.roboto(
    color: Colors.white54,
    fontSize: 11,
    letterSpacing: 1,
  ),
),

const SizedBox(height: 20),
      /// COPYRIGHT
      Text(
        "© 2026 Amanda Flower Shop • All Rights Reserved",
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          color: Colors.white38,
          fontSize: 10,
        ),
      ),
    ],
  ),
),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// ================= NAV ITEM =================
  Widget navItem({
    required IconData icon,
    required String text,
    required int index,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    final bool active =
        selectedNav == index;

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 250),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(30),

          gradient: active
              ? LinearGradient(
                  colors: [
                    goldColor,
                    goldColor.withOpacity(
                      0.75,
                    ),
                  ],
                )
              : null,

          color: active
              ? null
              : Colors.transparent,

          boxShadow: active
              ? [
                  BoxShadow(
                    color: goldColor
                        .withOpacity(0.35),
                    blurRadius: 14,
                    offset:
                        const Offset(0, 4),
                  ),
                ]
              : [],
        ),

        child: Row(
          children: [
            Stack(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: active
                      ? Colors.black
                      : Colors.white70,
                ),

                if (badge > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding:
                          const EdgeInsets.all(
                        4,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),

                      child: Text(
                        badge.toString(),

                        style:
                            GoogleFonts.roboto(
                          color:
                              Colors.white,
                          fontSize: 8,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 6),

            Text(
              text,

              style: GoogleFonts.roboto(
                color: active
                    ? Colors.black
                    : Colors.white70,
                fontSize: 12,
                fontWeight:
                    FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= BACKGROUND =================
  Widget sectionBackground({
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            "assets/assets/bg.jpg",
          ),

          fit: BoxFit.cover,

          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.82),
            BlendMode.darken,
          ),
        ),
      ),

      child: child,
    );
  }

  /// ================= TITLE =================
  Widget sectionTitle(String text) {
    return Text(
      text,

      textAlign: TextAlign.center,

      style:
          GoogleFonts.playfairDisplay(
        color: goldColor,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// ================= GRID =================
  Widget buildGrid(
    int crossAxisCount,
    List<List<String>> data,
  ) {
    final isMobile =
        MediaQuery.of(context).size.width <
            600;

    return GridView.builder(
      shrinkWrap: true,

      physics:
          const NeverScrollableScrollPhysics(),

      itemCount: data.length,

      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,

        crossAxisSpacing: 14,
        mainAxisSpacing: 14,

        childAspectRatio:
            isMobile ? 0.56 : 0.72,
      ),

      itemBuilder: (context, index) {
        return FlowerCard(
          image: data[index][0],
          title: data[index][1],
          price: data[index][2],

          fullName: widget.nama,
          phone: widget.hp,
          address: widget.alamat,

          onAddToCart: () {
            addToCart(
              data[index][0],
              data[index][1],
              data[index][2],
            );
          },
        );
      },
    );
  }
}

/// ================= SOCIAL ICON =================
Widget socialIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: goldColor.withOpacity(0.4),
      ),
    ),
    child: Icon(
      icon,
      size: 16,
      color: goldColor,
    ),
  );
}

/// ================= DATA =================
final sittingFlowers = [
  ["flower1.jpg", "Soft Pink Tulip", "IDR 155.999"],
  ["flower2.jpg", "Pastel Harmony", "IDR 287.299"],
  ["flower3.jpg", "White Lily", "IDR 320.000"],
  ["flower4.jpg", "Lavender Grace", "IDR 222.899"],
  ["flower5.jpg", "Golden Lily", "IDR 280.000"],
  ["flower6.jpg", "Blush Pink Lily", "IDR 450.000"],
];

final bestFlowers = [
  ["bunga1.jpg", "Red Roses", "IDR 380.459"],
  ["bunga2.jpg", "Sunflower", "IDR 255.000"],
  ["bunga3.jpg", "Lily Pink", "IDR 399.000"],
  ["bunga4.jpg", "White Tulip", "IDR 277.999"],
  ["bunga5.jpg", "Pastel Tulips", "IDR 280.000"],
  ["bunga6.jpg", "Purple Orchid", "IDR 229.999"],
];

/// ================= FLOWER CARD =================
class FlowerCard extends StatefulWidget {
  final String image;
  final String title;
  final String price;

  final String fullName;
  final String phone;
  final String address;

  final VoidCallback onAddToCart;

  const FlowerCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.onAddToCart,
  });

  @override
  State<FlowerCard> createState() =>
      _FlowerCardState();
}

class _FlowerCardState
    extends State<FlowerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 140),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
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
    final isMobile =
        MediaQuery.of(context).size.width <
            600;

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(22),

        color: Colors.white.withOpacity(
          0.05,
        ),

        border: Border.all(
          color: const Color(0x22D4AF37),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.28,
            ),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          /// IMAGE
          Expanded(
            flex: 6,

            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(22),
              ),

              child: Image.asset(
                "assets/assets/${widget.image}",

                width: double.infinity,
                height: double.infinity,

                fit: BoxFit.cover,
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            flex: 4,

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,

                children: [
                  Flexible(
                    child: Text(
                      widget.title,

                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,

                      textAlign:
                          TextAlign.center,

                      style:
                          GoogleFonts.playfairDisplay(
                        color: goldColor,
                        fontSize:
                            isMobile
                                ? 12
                                : 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  Text(
  widget.price,
  overflow: TextOverflow.ellipsis,
  style: GoogleFonts.roboto(
    color: Colors.white.withOpacity(0.85),
    fontSize: isMobile ? 11 : 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) =>
                            _controller.forward(),

                        onTapUp: (_) {
                          _controller.reverse();
                          goToDetail();
                        },

                        onTapCancel: () =>
                            _controller.reverse(),

                        child: ScaleTransition(
                          scale: _scale,

                          child: Container(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal:
                                  isMobile
                                      ? 10
                                      : 12,
                              vertical:
                                  isMobile
                                      ? 7
                                      : 8,
                            ),

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),

                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(
                                    0xFFD4AF37,
                                  ),
                                  Color(
                                    0xFFF7E7A1,
                                  ),
                                ],
                              ),
                            ),

                            child: Row(
                              children: [
                                const Icon(
                                  Icons
                                      .shopping_bag_outlined,
                                  size: 14,
                                  color:
                                      Colors.black,
                                ),

                                const SizedBox(
                                  width: 6,
                                ),

                                Text(
                                  "BUY",

                                  style:
                                      GoogleFonts
                                          .roboto(
                                    fontSize:
                                        isMobile
                                            ? 10
                                            : 11,
                                    color: Colors
                                        .black,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      GestureDetector(
                        onTap:
                            widget.onAddToCart,

                        child: Container(
                          padding:
                              EdgeInsets.symmetric(
                            horizontal:
                                isMobile
                                    ? 10
                                    : 12,
                            vertical:
                                isMobile
                                    ? 7
                                    : 8,
                          ),

                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),

                            color: Colors.white
                                .withOpacity(
                              0.08,
                            ),

                            border: Border.all(
                              color: goldColor
                                  .withOpacity(
                                0.4,
                              ),
                            ),
                          ),

                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .add_shopping_cart,
                                size: 14,
                                color:
                                    goldColor,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(
                                "ADD",

                                style:
                                    GoogleFonts
                                        .roboto(
                                  fontSize:
                                      isMobile
                                          ? 10
                                          : 11,
                                  color:
                                      goldColor,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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