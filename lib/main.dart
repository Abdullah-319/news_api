import 'package:flutter/material.dart';
import 'package:news_api/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xff344e41);
    // const primary = Color(0xff3a5a40);
    // const secondary = Color(0xff588157);
    // const primaryContainer = Color(0xffa3b18a);

    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          // primary: primary,
          // secondary: secondary,
          // primaryContainer: primaryContainer,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
