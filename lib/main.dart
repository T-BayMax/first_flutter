import 'dart:async';

import 'package:first_flutter/page/home_page.dart';
import 'package:first_flutter/page/login_page.dart';
import 'package:first_flutter/page/table_home/vector_home_details_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    // title: '推酷',
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/login': (_) => new LoginPage(),
      '/home': (_) => new HomePage(),
      '/home_page/details':(_)=>new VectorHomeDetailsPage(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    //设置启动图生效时间
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new HomePage()
        ), (route) => route == null);
   // Navigator.of(context).pushNamed('/home');
   // Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('./images/start_page_default_1.jpg'),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: new Image.asset(
          './images/start_logo.png',
          width: 200.0,
          height: 200.0,
        ),
      )

          //child:Container[new Image.asset('./images/start_page_default_1.jpg'),
          //
          ),
    );
  }
}
