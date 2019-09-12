import 'package:flutter/material.dart';
import './libs.dart';

import './zkapp1.dart';
import './zkapp2.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatefulWidget {
  @override
  _FirstScreenWidgetState createState() => _FirstScreenWidgetState();
}

class _FirstScreenWidgetState extends State {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                shape: StadiumBorder(),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Go to 2nd page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                }),
            SizedBox(height: 10),
            Text(
              'This is the first zerker app',
              style: new TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
            SizedBox(height: 20),
            _show ? Zerker(app: MyZKApp1(), clip: true, interactive: true, width: 350, height: 350) : SizedBox(height: 350),
            SizedBox(height: 20),
            RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('show or hide app'),
                onPressed: () {
                  setState(() {
                    _show = !_show;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second page'),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                shape: StadiumBorder(),
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Go back'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(height: 10),
            Text(
              'This is the second zerker app',
              style: new TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
            SizedBox(height: 20),
            Zerker(app: MyZKApp2(), clip: false, interactive: true, width: 350, height: 350),
          ],
        ),
      ),
    );
  }
}
