import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/balls.dart';
import 'package:pong/boundaries.dart';
import 'package:pong/fieldline.dart';
import 'package:pong/player_bar.dart';
import 'package:pong/scoretext.dart';

import 'ai_paddle.dart';

void main() {
  final game = PongGame();
  runApp(GameWidget(game: game));
}

class PongGame extends FlameGame
    with HasTappables, HasCollisionDetection, HasKeyboardHandlerComponents {
  PongGame();

  late final ScoreText aiPlayer;
  late final ScoreText player;

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(this);
    boundaries.forEach(add);

    addAll(
      [
        FieldLine(),
        aiPlayer = ScoreText(
          position: Vector2(
            size.x / 2 - 65,
            25,
          ),
        ),
        player = ScoreText(
          position: Vector2(
            size.x / 2 + 50,
            25,
          ),
        ),
        Paddle(),
        AiPaddle(),
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
