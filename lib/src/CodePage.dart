import 'package:flutter/material.dart';

class CodePage extends StatelessWidget {
  CodePage({this.otp});
  final String otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Verifikasi"),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context, true);
            // print(context.toString());
          },
        ),
      ),
      body: new Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 9.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                otp.toString(),
                style: TextStyle(fontSize: 30.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
