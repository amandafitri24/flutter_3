import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'first_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = true;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

/// 🔥 WAJIB ADA INI
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}