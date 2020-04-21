import 'package:flutter/material.dart';

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('about'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'modify splash screen',
                style: TextStyle(fontSize: 60, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
