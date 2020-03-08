import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gov_portal/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'model/scheme_list.dart';
import 'scheme_tile.dart';



class SchemeList extends StatefulWidget {

  static const String routeName = '/schemes';



  @override
  _SchemeList createState() => _SchemeList();

}

class _SchemeList extends State<SchemeList> {

  String barcode;
  AppBar appBar;


  Future<void> sendSelectedGenres() async {
    print(Schemes.selectedSchemes);
    final url = 'http://5bb1b084.ngrok.io/claim';
    final response = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "scheme": Schemes.selectedSchemes,
          "unique_hash": barcode,
        }));
    print(response.body);
  }



  @override
  Widget build(BuildContext context) {

    Map args = ModalRoute.of(context).settings.arguments as Map;

    barcode = args['barcode'];
    appBar = args['appbar'];

    // TODO: implement build
    return Scaffold(
      appBar: appBar,
      drawer: AppDrawer(appBar),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).orientation == Orientation.portrait
                    ? (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.01) *
                    0.1
                    : (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.07) *
                    0.2,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  "Please select one or more schemes",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ),
              Container(
                height: MediaQuery.of(context).orientation == Orientation.portrait
                    ? (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.04) *
                    0.8
                    : (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.09) *
                    0.6,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: Schemes.schemes.length,
                  itemBuilder: (ctx, i) {
                    return SchemeTile(scheme: Schemes.schemes[i],) ;
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).orientation == Orientation.portrait
                    ? (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.02) *
                    0.1
                    : (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).size.height * 0.07) *
                    0.2,
                alignment: Alignment.center,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                  color: Color.fromRGBO(143, 148, 251, 1),
                  onPressed: () {
                    sendSelectedGenres();
                  },
                  child: Text(
                    "CONFIRM",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}