import 'dart:math' show pi;

import 'package:flutter/material.dart';

main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeData theme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(changeBrightness),
      theme: theme,
    );
  }

  changeBrightness() {
    setState(() {
      theme = theme == ThemeData.light() ? ThemeData.dark() : ThemeData.light();
    });
  }
}

class Home extends StatefulWidget {
  final Function changeBrightness;

  Home(this.changeBrightness);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var checkBox = true;

  AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
        duration: Duration(seconds: 2),
        lowerBound: 0,
        upperBound: 360,
        vsync: this);
    animation.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              return Container(
                height: 100,
                width: 100,
                child: CustomPaint(
                  painter: Doom(animation.value.toInt(), context),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(Icons.color_lens),
        onPressed: () {
          widget.changeBrightness();
        },
      ),
    );
  }
}

class Doom extends CustomPainter {
  int value;

  BuildContext context;
  Paint _paint;

  Doom(this.value, this.context) {
    _paint = Paint()
      ..color = Theme.of(context).accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var center = size.center(Offset.zero);
    canvas.drawArc(Rect.fromCenter(center: center, height: 50, width: 50),
        degToRad(value), degToRad(60), false, _paint);
    canvas.drawArc(Rect.fromCenter(center: center, height: 40, width: 40),
        degToRad(180 - value), degToRad(60), false, _paint);
    canvas.drawArc(Rect.fromCenter(center: center, height: 30, width: 30),
        degToRad(180 + value), degToRad(60), false, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degToRad(int degree) {
    return degree * pi / 180;
  }
}
