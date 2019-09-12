import 'dart:math';
import 'package:flutter/material.dart';
import './libs.dart';

class MyZKApp1 extends ZKApp {
  bool _loaded = false;
  ZKButton _button;
  ZKText _title;
  ZKCircle _circle;
  List<ZKImage> _anyball = [];

  double _vx = 1.5;
  double _vy = .5;

  @override
  init() {
    this.debug = true;
    super.init();
    this.ratio = 2;
    stage.color = Colors.blue;

    Map<String, dynamic> urls = {
      "button": "assets/button.png",
      "emoji": "assets/emoji.png",
    };
    ZKAssets.preload(
        urls: urls,
        onLoad: () {
          _initScene();
          _loaded = true;
        });
  }

  _initScene() {
    _title = ZKText()
      ..position.x = appWidth / 2
      ..position.y = appHeight - 20
      ..text = "Please click button"
      ..setStyle(color: Colors.blue, backgroundColor: Colors.white, textAlign: TextAlign.center);
    stage.addChild(_title);

    _button = ZKButton("button")
      ..setScale(.5)
      ..anchor.y = 1
      ..position.x = size.width / 2
      ..position.y = size.height / 2;
    stage.addChild(_button);

    _circle = ZKCircle(60)
      ..color = Colors.white30
      ..position.x = size.width / 2
      ..position.y = size.height / 2;
    stage.addChildAt(_circle, 1);

    _addAction();
  }

  void _addAction() {
    _button.onTapUp = (event) {
      _appearBall();
    };

    _createBall();
  }

  void _createBall() {
    for (int i = 0; i < 6; i++) {
      ZKImage emoji = ZKImage("emoji");
      _anyball.add(emoji);
    }
  }

  void _appearBall() {
    for (int i = 0; i < _anyball.length; i++) {
      ZKImage emoji = _anyball[i]
        ..setScale(getRandomA2B(.3, 1))
        ..position.x = _button.position.x
        ..position.y = _button.position.y;
      stage.addChildAt(emoji, 1);

      int time = getRandomA2B(400, 600).toInt();
      double rotation = getRandomA2B(-300, 500);
      int r = 200;
      double posX = size.width / 2 + r * cos(getRandomA2B(0, 6));
      double posY = size.height / 2 + r * cos(getRandomA2B(0, 6));
      ZKTween(emoji).to({"rotation": rotation, "x": posX, "y": posY, "alpha": .6}, time).onComplete((target) {
        stage.removeChild(emoji);
      }).start();
    }
  }

  @override
  update(int time) {
    if (!_loaded) return;
    super.update(time);

    _circle.position.x += _vx;
    _circle.position.y += _vy;
    if (_circle.position.x + _circle.radius >= size.width || _circle.position.x - _circle.radius <= 0) {
      int symbol = _vx > 0 ? -1 : 1;
      double val = getRandomA2B(0.5, 3);
      _vx = symbol * val;
    }

    if (_circle.position.y + _circle.radius >= size.height || _circle.position.y - _circle.radius <= 0) {
      int symbol = _vy > 0 ? -1 : 1;
      double val = getRandomA2B(0.5, 3);
      _vy = symbol * val;
    }
  }
}
