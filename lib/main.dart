import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/ball.dart';
import 'package:pong/fieldline.dart';
import 'package:pong/player_paddle.dart';
import 'package:pong/scoretext.dart';

import 'ai_paddle.dart';

void main() {
  final game = PongGame();
  runApp(GameWidget(game: game));
}

class PongGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasKeyboardHandlerComponents {
  PongGame();

  late final ScoreText aiPlayer;
  late final ScoreText player;

  @override
  Future<void> onLoad() async {
    addAll(
      [
        ScreenHitbox(),
        FieldLine(),
        aiPlayer = ScoreText.aiScore(),
        player = ScoreText.playerScore(),
        PlayerPaddle(),
        AIPaddle(),
        Ball(),
      ],
    );
  }

  @override
  @mustCallSuper
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);

    return KeyEventResult.handled;
  }
}
