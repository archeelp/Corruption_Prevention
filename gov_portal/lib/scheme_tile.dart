import 'package:flutter/material.dart';
import 'model/scheme_list.dart';


class SchemeTile extends StatefulWidget {
  final String scheme;

  SchemeTile({this.scheme});

  @override
  _SchemeTileState createState() => _SchemeTileState();
}

class _SchemeTileState extends State<SchemeTile> {
  bool value = false;


  void select() {
    if (value) {
      setState(() {
        value = false;
        Schemes.selectedSchemes.remove(widget.scheme);
      });
    } else {
      setState(() {
        value = true;
        Schemes.selectedSchemes.clear();
        Schemes.selectedSchemes.add(widget.scheme);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.scheme,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          value: value,
          onChanged: (value) => select(),
          activeColor: Color.fromRGBO(143, 148, 251, 1),
          checkColor: Colors.black,
        ),
        Divider(),
      ],
    );
  }
}