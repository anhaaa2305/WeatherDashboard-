import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/providers/weather_provider.dart';
import 'package:weather_dashboard/screens/main_screen.dart';

import 'consts/theme_data.dart';
import 'controllers/MenuController.dart';
import 'providers/dark_theme_provider.dart';

void main() async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
    }
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCgYaPjCDbO6Bs5wkdvC3Prr46MWQbD5Zc",
        appId: "1:1029173790499:web:7800ca39c7a53095272e96",
        messagingSenderId: "1029173790499",
        projectId: "weatherdashboard-e6443",
        storageBucket: "weatherdashboard-e6443.firebasestorage.app",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    requestPermission();
  }

  Future<void> requestPermission() async {
    const permission = Permission.location;
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => WeatherProvider()),
            ChangeNotifierProvider(
              create: (_) => CustomMenuController(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Weather Dashboard',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
