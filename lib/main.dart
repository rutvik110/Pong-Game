import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pong/balls.dart';
import 'package:pong/boundaries.dart';
import 'package:pong/player_bar.dart';

import 'ai_paddle.dart';

void main() {
  final game = CompositionExample();
  runApp(GameWidget(game: game));
}

const TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 2);

class CompositionExample extends FlameGame
    with HasTappables, HasCollisionDetection, HasKeyboardHandlerComponents {
  static const description = '''
    This example shows how to compose a `BodyComponent` together with a normal
    Flame component. Click the ball to see the number increment.
  ''';

  CompositionExample();

  @override
  // TODO: implement debugMode
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    //  final screenHitBox = ScreenHitbox();

    final boundaries = createBoundaries(this);
    boundaries.forEach(add);

    final viewportCenter = camera.viewport.effectiveSize / 2;

    addAll(
      [
        // screenHitBox,
        Paddle(),
        AiPaddle(),
        Ball(Vector2(500, 10)),
      ],
    );
  }
}

// class TappableBall extends Ball with Tappable {
//   late final TextComponent textComponent;
//   int counter = 0;
//   late final TextPaint _textPaint;

//   TappableBall(super.position) {
//     originalPaint = Paint()..color = Colors.amber;
//     paint = originalPaint;
//   }

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     _textPaint = TextPaint(style: _textStyle);
//     textComponent = TextComponent(
//       text: counter.toString(),
//       textRenderer: _textPaint,
//     );
//     add(textComponent);
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     // This is unfortunately needed since [BodyComponent] will set all its
//     // children to `debugMode = true` currently, we should come up with a
//     // nicer solution to this.
//     textComponent.debugMode = false;
//     textComponent.text = counter.toString();
//   }

//   @override
//   bool onTapDown(_) {
//     counter++;
//     body.applyLinearImpulse(Vector2.random() * 1000);
//     paint = randomPaint();
//     return false;
//   }
// }
