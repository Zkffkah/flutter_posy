import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          _item.onTap();
        }, // handle your onTap here
        child: Container(
          height: 35.0,
          width: 50.0,
          child: new Center(
            child: new Text(_item.text,
                style: new TextStyle(
                    color: _item.isSelected ? Colors.white : Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
          ),
          decoration: new BoxDecoration(
            color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
            border: new Border.all(
                width: 1.0,
                color: _item.isSelected ? Colors.blueAccent : Colors.grey),
            borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
          ),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;
  GestureTapCallback onTap;

  RadioModel(this.isSelected, this.text, this.onTap);
}
