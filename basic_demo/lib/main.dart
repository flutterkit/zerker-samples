import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zerker/zerker.dart';

void main() => runApp(MyApp());
Random random = Random();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zerker Basic Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Zerker(app: MyZKApp(), clip: true, interactive: true),
    );
  }
}

class MyZKApp extends ZKApp {
  ZKNode _node;
  ZKRect _rect;
  ZKSprite _dino;
  ZKSprite _bigboy;
  ZKText _text;
  ZKScene _scene;
  ZKGraphic _graphic;
  ZKContainer _container;
  bool _loaded = false;
  double _index = 0;

  @override
  init() {
    super.init();
    ratio = 2;
    stage.color = Colors.deepPurple;
    _preload();
  }

  void _preload() {
    Map<String, dynamic> urls = {
      "bg": "bg.png",
      "dino": {"json": "dino.json", "image": "dino.png"},
      "bigboy": {"image": "bigboy.png", "width": 32.0, "height": 32.0}
    };

    ZKAssets.preload(
        baseUrl: "assets/",
        urls: urls,
        onProgress: (scale) {
          print("Assets loading ${scale * 100}%");
        },
        onLoad: () {
          _initScene();
          _loaded = true;
          print("Assets load Complete");
        });
  }

  void _initScene() {
    _scene = ZKScene();

    // add a node
    _node = ZKNode()
      ..debug = true
      ..position.x = size.width / 2
      ..position.y = size.height / 2
      ..color = Colors.indigo;
    _scene.addChild(_node);

    // add a image
    ZKImage bg = ZKImage("bg")
      ..alpha = .3
      ..setScale(1.5)
      ..setPosition(size.width / 2, size.height / 2);
    stage.addChildAt(bg, 0);

    // add a rect
    var p = getRandomPosition();
    _rect = ZKRect(100, 100)
      ..alpha = 0.6
      ..color = getRandomColor()
      ..setPosition(p.x, p.y);
    stage.addChild(_rect);

    // add a text
    _text = ZKText()
      ..position.x = 300
      ..position.y = 300
      ..text = "hello world"
      ..setStyle(fontSize: 30, color: Colors.blueGrey, backgroundColor: Colors.red[50]);
    stage.addChild(_text);

    // add a graphic
    _graphic = ZKGraphic()
      ..setPosition(size.width / 2, size.height / 2)
      ..setStyle(color: Colors.white70)
      ..drawRect(0.0, 0.0, 100.0, 100.0)
      ..setStyle(color: Colors.cyan)
      ..drawRect(-10.0, -250.0, 15.0, 200.0)
      ..setStyle(color: Colors.red)
      ..drawCircle(-120.0, -10.0, 50.0)
      ..setStyle(color: Colors.green)
      ..drawTriangle(-120.0, -10.0, 50.0, 50.0, 150.0, 250.0);
    stage.addChildAt(_graphic, 1);

    // add a sprite by spritesheet
    _bigboy = ZKSprite(key: "bigboy")
      ..expansion = 0
      ..setScale(6)
      ..setPosition(size.width / 2, size.height / 2)
      ..animator.make("front", ['0-4'])
      ..animator.make("left", ['5-9'])
      ..animator.make("after", ['10-14'])
      ..animator.make("right", ['15-19'])
      ..animator.play("front", 8, true)
      ..onTapDown = (event) {
        List<String> _list = ["front", "left", "after", "right"];
        _bigboy.animator.play(_list[(++_bigboy.expansion) % 4], 8, true);
      };
    _scene.addChild(_bigboy);

    // add a dino sprite
    _dino = ZKSprite(key: "dino")
      ..id = "dino"
      ..debug = true
      ..expansion = 0
      ..anchor.x = 0.1
      ..anchor.y = 0.9
      ..position.x = 50
      ..position.y = size.height - 70
      ..setScale(1.6)
      ..animator.make("run")
      ..animator.play("run", 8, true);
    _scene.addChild(_dino);

    _addAnyDot();
    _addAction();

    ZKText title = ZKText()
      ..position.x = size.width / 2
      ..position.y = 50
      ..text = "Please click on any area of ​​the scene"
      ..setStyle(fontSize: 12, color: Colors.white, textAlign: TextAlign.center);
    stage.addChild(title);

    stage.addChild(_scene);
    _scene.moveIn(time: 1000, y: 300, ease: Ease.back.easeOut);
  }

  _addAnyDot() {
    _container = ZKContainer();
    double angle = 0;
    double r = 80;
    double w = 25;
    double n = 8;

    for (int i = 0; i < n; i++) {
      ZKNode dot;

      if (i % 2 == 0)
        dot = ZKRect(w, w, getRandomColor());
      else
        dot = ZKCircle(w / 4, getRandomColor());

      angle = (i * pi * 2) / n;
      dot.setPosition(r * cos(angle), r * sin(angle));
      _container.addChild(dot);

      Map<String, dynamic> info = {"type": dot.type, "index": i, "r": r, "w": w, "n": n, "angle": angle};
      dot.expansion = info;
    }

    _container.setPosition(size.width / 2, 200);
    stage.addChild(_container);
  }

  _addAction() {
    stage.onTapDown = (event) {
      // tween text
      ZKTween(_text.position).to({"x": event.dx, "y": event.dy}, 2000).easing(Ease.elastic.easeOut).start();

      // tween sprite
      double scale = random.nextDouble() * 12 + 4;
      double dis = 80;
      ZKTween(_bigboy)
          .to({"x": event.dx + dis, "y": event.dy + dis, "scaleX": scale, "scaleY": scale}, 1000)
          .easing(Ease.back.easeInOut)
          .start();
    };
  }

  @override
  update(int time) {
    if (!_loaded) return;
    super.update(time);

    _index++;

    _dino.position.x = cos(_dino.expansion += 0.01) * 100 + 150;

    _node.position.x += 0.1;
    _node.position.y += 0.13;
    _node.rotation -= 1;

    _graphic.rotation -= 0.2;
    _text.rotation++;

    _container.rotation--;

    _rect.rotation -= 0.5;

    _container.forEach((ZKNode child) {
      Map<String, dynamic> info = child.expansion;
      double r = info["r"];
      String type = info["type"];
      double angle = info["angle"];
      double R = type == "ZKCircle" ? r + sin(_index / 10).abs() * 80 : r + cos(_index / 10) * 100;
      child.setPosition(R * cos(angle), R * sin(angle));
    });
  }

  @override
  customDraw(Canvas canvas) {}

  @override
  void dispose() {
    super.dispose();

    ZKBus.off("SHOW");
  }
}
