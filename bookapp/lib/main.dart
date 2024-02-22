import 'package:flutter/material.dart';
import 'package:bookapp/pages/home.dart';
import 'package:bookapp/pages/wishlist.dart';
import 'package:bookapp/pages/reading_now.dart';
import 'package:bookapp/pages/read.dart';
import 'package:bookapp/pages/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Light theme configuration
    final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness: Brightness.light, // Explicitly set brightness for light theme
      ),
      useMaterial3: true,
    );

    // Dark theme configuration
    final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.greenAccent,
        brightness: Brightness.dark, // Explicitly set brightness for dark theme
      ),
      useMaterial3: true,
    );


    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme, // Use the light theme
      darkTheme: darkTheme, // Use the dark theme
      themeMode: ThemeMode.system, // Use system theme mode
      initialRoute: '/', // The initial route when the app starts
      routes: {
        '/': (context) => Loading(),
        '/second': (context) => HomePage(),
        '/third': (context) => Wishlist(),
        '/fourth': (context) => ReadingNow(),
        '/fifth': (context) => Read(),
        // Add more routes as needed
      },
    );
  }
}

