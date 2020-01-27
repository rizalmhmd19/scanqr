import 'package:flutter/material.dart';
import 'package:scanqr/src/CodePage.dart';
import 'package:scanqr/src/About.dart';
import 'package:scanqr/src/Profile.dart';
import 'package:scanqr/src/app.dart';

void main() => runApp(ScanApp());

String imei = "";
String otp = "";
int id;

class ScanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scan QR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanScreen(),
      //Routes
      routes: <String, WidgetBuilder>{
        '/CodePage': (BuildContext context) => new CodePage(otp: otp),
        '/ScanScreen': (BuildContext context) => new ScanScreen(),
        '/About': (BuildContext context) => new About(),
        '/Profile': (BuildContext context) => new Profile(id: id),
      },
    );
  }
}
