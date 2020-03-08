import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final AppBar appBar;

  AppDrawer(this.appBar);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Container(
        color: Color.fromRGBO(143, 148, 251, 1),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).size.height * 0.01) *
                  0.3
                  : (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).size.height * 0.07) *
                  0.5,
              alignment: Alignment.center,

              child: Image.asset(
                'assets/images/gov.png',
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).size.height * 0.01) *
                  0.82
                  : (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).size.height * 0.07) *
                  0.9,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  InkWell(
                    onTap: null,
                    child: ListTile(
                      leading: Icon(
                        Icons.movie,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Schemes",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: null,
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      title: Text(
                        "About Us",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}