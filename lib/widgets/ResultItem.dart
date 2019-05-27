import 'package:flutter/material.dart';

class ResultItem extends StatelessWidget {
  final String _leftText;
  final String _rightText;

  ResultItem(this._leftText, this._rightText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Center(
            child: new Text(_leftText,
                style: new TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
          ),
          new Center(
            child: new Text(_rightText,
                style: new TextStyle(
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
          )
        ],
      ),
    );
  }
}
