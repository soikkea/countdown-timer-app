import 'dart:math' as math;

import 'package:flutter/material.dart';

class Circle {
  final double fill;
  final Color color;

  const Circle({
    required this.fill,
    required this.color,
  });
}

const circlesMaxSize = 500.0;

List<Circle> buildCirclesFromDuration(
    Duration duration, Duration fullDuration) {
  final list = <Circle>[];

  final days = duration.inDays / fullDuration.inDays;
  list.add(Circle(fill: days.isNaN ? 0.0 : days, color: Colors.blue));
  final hours = (duration.inHours % 24) / 24;
  list.add(Circle(fill: hours, color: Colors.green));
  final minutes = (duration.inMinutes % 60) / 60;
  list.add(Circle(fill: minutes, color: Colors.yellow));
  final seconds = (duration.inSeconds % 60) / 60;
  list.add(Circle(fill: seconds, color: Colors.red));

  return list;
}

class CirclesWidget extends StatelessWidget {
  const CirclesWidget({
    Key? key,
    required this.circles,
    this.children = const <Widget>[],
  }) : super(key: key);

  final List<Circle> circles;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return DecoratedBox(
          decoration: CirclesDecoration(circles: circles),
          child: Container(
            height: constraints.maxHeight,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ));
    }));
  }
}

class CirclesDecoration extends Decoration {
  const CirclesDecoration({
    required this.circles,
  });

  final List<Circle> circles;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclesBoxPainter(
      circles: circles,
    );
  }
}

class _CirclesBoxPainter extends BoxPainter {
  _CirclesBoxPainter({
    required this.circles,
  });

  final List<Circle> circles;

  static const double wholeRadians = 2 * math.pi;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final outerRadius =
        math.min(configuration.size!.width, configuration.size!.height) / 2;
    final strokeWidth = outerRadius / math.max(circles.length, 1);
    const angleOffset = -0.25;

    for (var i = 0; i < circles.length; i++) {
      final rect = Rect.fromCircle(
        center: configuration.size!.center(offset),
        radius: outerRadius - strokeWidth * i,
      );
      final paint = Paint()..color = circles[i].color
          // TODO
          // ..strokeCap = StrokeCap.round
          // ..strokeWidth = strokeWidth
          // ..style = PaintingStyle.stroke
          ;
      canvas.drawArc(rect, _fractionToRadians(0.0 + angleOffset),
          _fractionToRadians(circles[i].fill), true, paint);
    }
  }

  double _fractionToRadians(double amount) {
    return amount * wholeRadians;
  }
}
