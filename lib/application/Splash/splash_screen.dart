import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    Timer(const Duration(seconds: 2), () {
      if (token == null) {
        Navigator.pushReplacementNamed(
          context,
          '/login',
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: primaryLight,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Images.loginBg),
                fit: BoxFit.fitWidth,
                opacity: 30,
                alignment: Alignment.center),
          ),
        ),
      ),
    );
  }
}
