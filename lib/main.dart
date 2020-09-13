import 'package:flutter/material.dart';
import 'package:mhslite/screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue,visualDensity: VisualDensity.adaptivePlatformDensity,),
      home:SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}