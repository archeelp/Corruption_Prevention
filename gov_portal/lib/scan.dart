import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gov_portal/select_scheme.dart';

import 'widgets/app_drawer.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = '/scan';

  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  final appBar = AppBar(
    title: Text(
      "Scan",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color.fromRGBO(143, 148, 251, 1),
  );

  void select(){
    Navigator.of(context).pushNamed(SchemeList.routeName,arguments: {
      'barcode' : barcode,
      'appbar' : appBar,
    });
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
        drawer: AppDrawer(appBar),
        appBar: appBar,
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: scan,
                    child: const Text('START CAMERA SCAN')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  barcode,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: RaisedButton(
                  color: Color.fromRGBO(143, 148, 251, 1),
                  onPressed: select,
                  child: Text("Proceed to select schemes"),
                ),
              )
            ],
          ),
        ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        print(barcode);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
