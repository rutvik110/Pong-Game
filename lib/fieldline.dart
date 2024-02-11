import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pong/main.dart';

class FieldLine extends Component with HasGameRef<PongGame> {
  final linePainter = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..translate(gameRef.size.x / 2, 0);

    for (var i = 0; i < gameRef.size.y / 10; i++) {
      if (i.isEven) {
        canvas.drawRect(
          Rect.fromLTWH(
            0,
            (10 * i).toDouble(),
            10,
            10,
          ),
          linePainter,
        );
      }
    }
    canvas.restore();
  }
}
