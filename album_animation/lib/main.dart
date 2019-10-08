import 'package:flutter/material.dart';
import 'package:zerker/zerker.dart';
import './select.dart';

void main() => runApp(MyApp());

List<String> itemsList = ['Zoom', 'Rotate', 'Move', 'Expand'];
String switchAnimationType = 'Zoom';
Size cusSize = Size(360, 360);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album switch animation demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Zerker Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Zerker(app: MyZKApp(), clip: false, interactive: false, width: cusSize.width, height: cusSize.height),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    color: Color.fromRGBO(118, 185, 0, 1.0),
                    textColor: Colors.white,
                    onPressed: () {
                      ZKBus.emit("SWITCH", "prev");
                    },
                    child: Text('prev')),
                Select(
                  itemsList: itemsList,
                  onChanged: (String newValue) {
                    switchAnimationType = newValue;
                  },
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    color: Color.fromRGBO(118, 185, 0, 1.0),
                    textColor: Colors.white,
                    onPressed: () {
                      ZKBus.emit("SWITCH", "next");
                    },
                    child: Text('next')),
              ],
            ),
          ],
        ));
  }
}

class MyZKApp extends ZKApp {
  ZKContainer _currCon, _prevCon;

  List<ZKContainer> _conList = [];
  List<ZKImage> _albumList = [];
  int _currIndex = 0;
  int _totalCount = 9;
  bool _enabled = true;

  @override
  void init() {
    super.init();

    ratio = 2.2;
    _initScene();
  }

  void _initScene() {
    // add img con
    for (int i = 0; i < 2; i++) {
      ZKContainer con = ZKContainer();
      con.setPosition(cusSize.width / 2, cusSize.height / 2);
      _conList.add(con);
      stage.addChild(con);
    }

    // create any album images;
    for (int i = 1; i <= _totalCount; i++) {
      _albumList.add(ZKImage("assets/0${i.toString()}.jpg"));
    }

    ZKBus.on("SWITCH", _addSwitchAnimation);
    _addSwitchAnimation();
  }

  void _addSwitchAnimation([String direction = "next"]) {
    if (_enabled == false) return;

    _switchIndex(direction);
    _switchCon();

    int time = 600;
    var easeOutFunc, easeInFunc;
    Map<String, double> targetObj = {};
    switch (switchAnimationType) {
      case "Zoom":
        _currCon.scale.x = .1;
        _currCon.scale.y = .1;
        _currCon.alpha = 0;
        _currCon.rotation = 0;
        targetObj["alpha"] = 0;
        targetObj["scaleY"] = .1;

        easeInFunc = Ease.back.easeOut;
        easeOutFunc = Ease.back.easeIn;
        break;

      case "Rotate":
        _currCon.scale.x = .1;
        _currCon.scale.y = .1;
        _currCon.alpha = 0;
        _currCon.rotation = 220;
        targetObj["rotation"] = -220;
        targetObj["alpha"] = 0;
        targetObj["scaleX"] = .1;
        targetObj["scaleY"] = .1;

        easeInFunc = Ease.cubic.easeOut;
        easeOutFunc = Ease.cubic.easeIn;
        break;

      case "Move":
        _currCon.scale.x = .3;
        _currCon.scale.y = .3;
        _currCon.alpha = 0;
        _currCon.rotation = 0;
        _currCon.position.x = cusSize.width / 2 - 300;

        targetObj["x"] = cusSize.width / 2 + 300;
        targetObj["rotation"] = 0;
        targetObj["alpha"] = 0;
        targetObj["scaleX"] = .3;
        targetObj["scaleY"] = .3;

        easeInFunc = Ease.quart.easeOut;
        easeOutFunc = Ease.quart.easeIn;
        break;

      case "Expand":
        _currCon.scale.x = .1;
        _currCon.scale.y = 1;
        _currCon.alpha = 0;
        _currCon.rotation = 0;
        _currCon.position.x = cusSize.width / 2 - 200;

        targetObj["x"] = cusSize.width / 2 + 200;
        targetObj["rotation"] = 0;
        targetObj["alpha"] = 0;
        targetObj["scaleX"] = .1;
        targetObj["scaleY"] = 1;

        easeInFunc = Ease.quart.easeOut;
        easeOutFunc = Ease.quart.easeIn;
        break;
    }

    ZKTween(_currCon)
        .to({"x": cusSize.width / 2, "y": cusSize.height / 2, "scaleX": 1, "scaleY": 1, "alpha": 1, "rotation": 0}, time)
        .delay(100)
        .easing(easeInFunc)
        .onComplete((obj) {
          _enabled = true;
        })
        .start();

    ZKTween(_prevCon).to(targetObj, time).easing(easeOutFunc).onComplete((obj) {
      _empty(_prevCon);
    }).start();

    _enabled = false;
  }

  void _switchIndex(String direction) {
    if (direction == "next") {
      _currIndex++;
    } else {
      _currIndex--;
    }

    if (_currIndex >= _totalCount) _currIndex = 0;
    if (_currIndex < 0) _currIndex = _totalCount - 1;
  }

  void _switchCon() {
    if (_currCon == null) {
      _currCon = _conList[0];
      _prevCon = _conList[1];
    } else {
      _prevCon = _currCon;
      if (_currCon == _conList[0]) {
        _currCon = _conList[1];
      } else {
        _currCon = _conList[0];
      }
    }

    _empty(_currCon).addChild(_albumList[_currIndex]);
    _addChildTo(_currCon, stage);
  }

  void _addChildTo(ZKNode sub, ZKContainer parent) {
    if (sub.parent == parent) {
      parent.removeChild(sub);
      parent.addChild(sub);
    } else {
      parent.addChild(sub);
    }
  }

  ZKContainer _empty(ZKContainer con) {
    for (int i = con.children.length - 1; i >= 0; i--) {
      con.removeChild(con.children[i]);
    }

    return con;
  }

  @override
  void dispose() {
    super.dispose();
    ZKBus.off("SWITCH");
  }
}
