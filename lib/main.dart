import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
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

const TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 2);

class PongGame extends FlameGame
    with HasTappables, HasCollisionDetection, HasKeyboardHandlerComponents {
  static const description = '''
    This example shows how to compose a `BodyComponent` together with a normal
    Flame component. Click the ball to see the number increment.
  ''';

  PongGame();

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  late final ScoreText aiPlayer;
  late final ScoreText player;

  @override
  Future<void> onLoad() async {
    //  final screenHitBox = ScreenHitbox();

    final boundaries = createBoundaries(this);
    boundaries.forEach(add);

    // final viewportCenter = camera.viewport.effectiveSize / 2;

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
        Ball(Vector2(500, 10)),
      ],
    );
  }
}
