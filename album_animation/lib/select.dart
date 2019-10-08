import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  final List<String> itemsList;
  final Function onChanged;

  const Select({Key key, this.onChanged, this.itemsList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomCombinedWidgetState();
  }
}

class CustomCombinedWidgetState extends State<Select> {
  String _val;

  @override
  Widget build(BuildContext context) {
    if (_val == null) _val = this.widget.itemsList[0];

    return DropdownButton<String>(
      value: _val,
      onChanged: (String newValue) {
        this.setState(() {
          _val = newValue;
          this.widget.onChanged(newValue);
        });
      },
      items: this.widget.itemsList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
