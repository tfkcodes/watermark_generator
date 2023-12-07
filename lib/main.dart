import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watermark_generator/views/home_page.dart';

void main() {
  runApp(const WatermarkApp());
}

class WatermarkApp extends StatelessWidget {
  const WatermarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
