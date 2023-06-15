import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/eco_farm_final.png'),
        splashIconSize: 500,
        duration: 2500,
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.yellow.shade500,
        nextScreen: MyHomePage(),

      ),
    );
  }
}

