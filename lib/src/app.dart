import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:scanqr/main.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";
  String isLogin = "";

  var cron = new Cron();

  @override
  void initState() {
    super.initState();
    _getImei();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void ceklogin() {
    if (isLogin == "" || isLogin == null || isLogin != '1' || isLogin == '0') {
      cron.schedule(new Schedule.parse('1 * * * * *'), () async {
        final response = await http.get("http://192.168.2.72/Api/login/active");

        var res = json.decode(response.body);
        setState(() {
          isLogin = res['data']['is_login'].toString();
        });
        if (isLogin == '1') {
          print(isLogin);
          cron.close();
          showDialog(
              context: _scaffoldState.currentContext,
              builder: (context) {
                return Text("Login Berhasil");
              });
        } else {
          print(isLogin);
        }
        // print(isLogin);
      });
    }
  }

  Future _getImei() async {
    imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
  }

  Future scan() async {
    try {
      barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
      _login();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = "Camera permission not granted!";
        });
      } else {
        setState(() {
          this.barcode = "Unknown error : $e";
        });
      }
    } on FormatException {
      setState(() {
        this.barcode =
            'User returned using the "back"-button before scanning anything';
      });
    } catch (e) {
      setState(() {
        this.barcode = "Unkown error:$e";
      });
    }
  }

  Future _login() async {
    final response = await http.post(barcode, body: {"imei": imei});

    var res = json.decode(response.body);
    // print(res);
    if (res['message'] == 'Failed') {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: Text(res['data'].toString()),
      ));
    } else {
      otp = res['data']['otp'].toString();
      Navigator.pushNamed(context, '/CodePage');
    }

    return res['data'];
  }

  Future<List> log(String menu) async {
    final response = await http.post('http://192.168.3.73/Api/auth/log_menu',
        body: {"imei": imei, "menu": menu});
    var res = json.decode(response.body);
    // print(res['data'][0]['id']);
    setState(() {
      id = int.parse(res['data'][0]['id']);
    });
    await Navigator.pushNamed(context, '/$menu');
  }

  Future<bool> onBackPress() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you really want to exit the app?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          title: new Text("QR SCAN"),
          centerTitle: true,
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  splashColor: Colors.grey,
                  onPressed: scan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.scanner,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Scan",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text("Click here to scan QR")
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                      onPressed: () {
                        log("Profile");
                        // Navigator.pushNamed(context, '/Profile');
                      },
                      child: Column(
                        children: <Widget>[Text("Profile")],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: FlatButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                      child: Column(
                        children: <Widget>[Text("About")],
                      ),
                      onPressed: () {
                        log("About");
                        // Navigator.pushNamed(context, '/About');
                      },
                    ),
                  ),
                  Text(
                    imei,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
