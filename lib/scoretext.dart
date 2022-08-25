import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameRef<FlameGame> {
  late int score;

  final TextPaint _textPaint = TextPaint();

  ScoreText({
    required Vector2 position,
  }) : super(position: position);

  @override
  Future<void>? onLoad() {
    score = 0;
    // TODO: implement onLoad
    text = score.toString();

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, '$score', Vector2.zero());
  }
}
