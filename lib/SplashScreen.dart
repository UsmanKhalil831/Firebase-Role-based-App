import 'dart:async';

import 'package:app/LoginScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    Timer(const Duration(seconds: 5), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
       });
       super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(child: Center(
        child: Text('splash screen'),
      ),)
    );
  }
}