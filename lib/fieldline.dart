import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pong/main.dart';

class FieldLine extends Component with HasGameRef<PongGame> {
  final linePainter = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..translate(gameRef.size.x / 2 - 10, 10);

    for (var i = 0; i < gameRef.size.y / 20; i++) {
      canvas
        ..drawRect(Vector2.all(10).toRect(), linePainter)
        ..translate(0, 20 * 2);
    }
    canvas.restore();
  }
}
