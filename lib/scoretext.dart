import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pong/main.dart';

class ScoreText extends TextComponent with HasGameRef<PongGame> {
  ScoreText({
    required this.isPlayer,
  }) : super(anchor: isPlayer ? Anchor.topLeft : Anchor.topRight);

  final TextPaint _textPaint = TextPaint();
  final bool isPlayer;
  int score = 0;

  @override
  Future<void> onLoad() async {
    final textOffset = (isPlayer ? 40 : -40);
    position = Vector2(gameRef.size.x / 2 + textOffset, 50);
    text = score.toString();

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, '$score', Vector2.zero());
  }
}
