import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Center(
        child: Text(
          'Advaya',
          style: TextStyle(
              color: Colors.orange,
              fontFamily: "Dancing Script",
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
