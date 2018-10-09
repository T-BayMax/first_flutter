import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('./images/login_bg.png',
        fit: BoxFit.fill,),
      ),
    );
  }
}
