import 'package:flutter/material.dart';
import 'package:scanqr/main.dart';
import 'package:http/http.dart' as http;

class About extends StatefulWidget {
  @override
  _About createState() => new _About();
}

class _About extends State<About> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    end();
  }

  Future end() async {
    await http.post('http://192.168.2.72/Api/auth/end_menu',
        body: {"id": id.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About"),
      ),
      body: new Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 9.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("About Menu"),
              RaisedButton(
                color: Colors.cyan,
                onPressed: () => Navigator.pushNamed(context, '/Profile'),
                child: Column(
                  children: <Widget>[
                    Text("Profile"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
