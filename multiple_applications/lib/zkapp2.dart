import 'dart:math';
import 'package:flutter/material.dart';
import './libs.dart';

class MyZKApp2 extends ZKApp {
  bool _loaded = false;
  ZKImage _hand;
  ZKText _title;
  ZKCircle _circle;
  ZKImage _rock;
  ZKImage _hert;

  double _vx = 1.5;
  double _vy = .5;

  @override
  init() {
    this.debug = true;
    super.init();
    this.ratio = 2;
    stage.color = Colors.green;

    Map<String, dynamic> urls = {
      "rock": "assets/rock.png",
      "hand": "assets/hand.png",
      "hert": "assets/hert.png",
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
      ..text = "Please click hand"
      ..setStyle(color: Colors.blue, backgroundColor: Colors.white, textAlign: TextAlign.center);
    stage.addChild(_title);

    _hand = ZKImage("hand")
      ..setScale(.5)
      ..anchor.y = 1
      ..position.x = size.width / 2
      ..position.y = size.height / 2;
    stage.addChild(_hand);

    _circle = ZKCircle(50)
      ..color = Colors.white30
      ..position.x = size.width / 2
      ..position.y = size.height / 2;
    stage.addChildAt(_circle, 1);

    _addAction();
  }

  void _addAction() {
    _hand.onTapDown = (event) {
      _appearRock();
      _appearHert();
      _rotateHand();
    };
  }

  void _rotateHand() {
    ZKTween(_hand).to({"rotation": 360}, 300).onComplete((target) {
      _hand.rotation = 0;
    }).start();
  }

  void _appearRock() {
    if (_rock == null) _rock = ZKImage("rock");

    _rock
      ..setScale(getRandomA2B(1.5, 2.5))
      ..position.x = _hand.position.x
      ..position.y = size.height + 200;
    stage.addChild(_rock);

    int time = getRandomA2B(500, 800).toInt();
    ZKTween(_rock).to({"y": -200}, time).onComplete((target) {
      stage.removeChild(_rock);
    }).start();
  }

  void _appearHert() {
    if (_hert == null) _hert = ZKImage("hert");

    _hert
      ..alpha = 1
      ..setScale(.2)
      ..position.x = _hand.position.x
      ..position.y = _hand.position.y;
    stage.addChild(_hert);

    int time = getRandomA2B(500, 800).toInt();
    ZKTween(_hert).to({"scaleX": 4, "scaleY": 4, "alpha": 0}, time).onComplete((target) {
      stage.removeChild(_hert);
    }).start();
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
