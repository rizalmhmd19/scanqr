import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, true);
            print(context.toString());
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
              Text("Profile Menu"),
            ],
          ),
        ),
      ),
    );
  }
}
