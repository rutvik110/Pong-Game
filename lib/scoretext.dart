import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pong/main.dart';

class ScoreText extends TextComponent with HasGameRef<PongGame> {
  late int score;

  ScoreText.aiScore({
    this.score = 0,
  })  : _textPaint = TextPaint(textDirection: TextDirection.ltr),
        super(
          anchor: Anchor.center,
        );

  ScoreText.playerScore({
    this.score = 0,
  })  : _textPaint = TextPaint(textDirection: TextDirection.rtl),
        super(
          anchor: Anchor.center,
        );

  late final TextPaint _textPaint;

  @override
  Future<void> onLoad() async {
    score = 0;
    final textOffset = (_textPaint.textDirection == TextDirection.ltr ? -1 : 1) * 50;
    position.setValues(gameRef.size.x / 2 + textOffset, gameRef.size.y * 0.1);
    text = score.toString();

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, '$score', Vector2.zero());
  }
}
