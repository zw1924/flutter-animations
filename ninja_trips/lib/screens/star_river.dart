import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ZWStarRiver extends StatefulWidget {
  final double width;
  final double height;
  ZWStarRiver({Key key, this.width, this.height}) : super(key: key);

  @override
  _ZWStarRiverState createState() => _ZWStarRiverState();
}

class _ZWStarRiverState extends State<ZWStarRiver>
    with SingleTickerProviderStateMixin {
  ZWZeus zeus;

  Ticker _ticker;

  @override
  void initState() {
    zeus = ZWZeus(widget.width, widget.height);
    _ticker = createTicker(_tick)..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    zeus.tick();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: CustomPaint(
        painter: ZWStarRiverPainter(zeus: zeus),
      ),
    );
  }
}

class ZWStarRiverPainter extends CustomPainter {
  ZWZeus zeus;

  ZWStarRiverPainter({this.zeus}) : super(repaint: zeus);

  @override
  void paint(Canvas canvas, Size size) {
    zeus.stars.forEach((star) {
      var pos = star.current;

      var paint = Paint()
        ..color = star.color.withAlpha((255 * star.alpha).floor())
        ..strokeWidth = star.size
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, star.size, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ZWZeus extends ChangeNotifier {
  final double width;
  final double height;

  List<ZWStar> stars;

  double acceleration = 1.0; // 1.0 - 3.0

  Rect initStarRect;

  ZWZeus(this.width, this.height) {
    initStarRect = Rect.fromCenter(
        center: Offset(width / 2.0, height / 2.0), width: width/2.0, height: height/2.0);
    prepareMagic();
  }

  prepareMagic() {
    stars = [];
    for (int i = 0; i < 100; i++) {
      stars.add(initStar(initStarRect));
    }
  }

  initStar(Rect startRect) {
    return ZWStar(Color(0xffffffff), startRect);
  }

  tick() {
    Rect layoutRect = Rect.fromLTWH(0, 0, width, height);
    List<ZWStar> activeStars = [];
    stars.forEach((star) {
      star.lightUpStar(acceleration);
      if (star.life <= 0) {
        return;
      }
      if (!layoutRect.contains(star.current)) {
        return;
      }
      activeStars.add(star);
    });

    int add = max(100 - activeStars.length, 0);

    for (int i = 0; i < add; i++) {
      activeStars.add(initStar(initStarRect));
    }
    stars = activeStars;

    notifyListeners();
  }
}

class ZWStar {
  // 背景色
  final Color color;
  // 起始点
  Offset start;

  // 发射轨迹角度  0 - 359
  int _angle;

  // 10 - 20 s 生命周期 按每秒60频率刷新
  int life;
  // 1 到 10 移动速度
  double _speed;

  ZWStar(this.color, Rect initStarRect) {
    _angle = rndAngle();
    Rect starRect;
    if (_angle <= 90) {
      starRect = Rect.fromLTWH(initStarRect.center.dx, initStarRect.top,
          initStarRect.width / 2.0, initStarRect.height / 2.0);
    } else if (_angle <= 180) {
       starRect = Rect.fromLTWH(initStarRect.left, initStarRect.top,
          initStarRect.width / 2.0, initStarRect.height / 2.0);
    } else if (_angle <= 270) {
       starRect = Rect.fromLTWH(initStarRect.left, initStarRect.center.dy,
          initStarRect.width / 2.0, initStarRect.height / 2.0);
    } else if (_angle <= 360) {
       starRect = Rect.fromLTWH(initStarRect.center.dx, initStarRect.center.dy,
          initStarRect.width / 2.0, initStarRect.height / 2.0);
    } 
    double startX = Random().nextDouble() * starRect.width  + starRect.left;
    double startY = Random().nextDouble() * starRect.height + starRect.top;

    start = Offset(startX,startY);
    life = rndLife();
    _speed = rndSpeed();
  }

  // 0.1 - 1。0
  double alpha = 0.1;

  Offset _current;
  double size = 1; //0.5 - 1.5

  Offset get current => _current ?? start;

  lightUpStar(double acceleration) {
    life--;
    if (alpha < 1) {
      alpha += 0.01 * _speed;
      alpha = min(alpha, 1.0);
    }
    double angleV = _angle / 180.0 * pi;

    double cosAngleV = cos(angleV);
    double sinAngleV = sin(angleV);

    double offsetX = current.dx + _speed * cosAngleV * acceleration;
    double offsetY = current.dy - _speed * sinAngleV * acceleration;

    _current = Offset(offsetX, offsetY);

    if (size < 0.5) {
      size += 0.01;
    }
  }

  rndAngle() {
    return Random().nextInt(360);
  }

  rndLife() {
    return Random().nextInt(600) + 600;
  }

  rndSpeed() {
    return Random().nextDouble() * 0.1 + 0.1;
  }
}
