import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum KeyEventEnum {
  none,
  down,
  up,
}

class Paddle extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  // Paddle({});
  late final RectangleHitbox paddleHitBox;
  late final RectangleComponent paddle;

  static const double speed = 400;

  late final KeyboardListenerComponent keyboardListenerComponent;
  KeyEventEnum keyEventEnum = KeyEventEnum.none;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad

    final worldRect = gameRef.size.toRect();

    final size = Vector2(10, 100);
    position.x = worldRect.width * 0.9 - 10;
    position.y = worldRect.height / 2 - size.y / 2;
    paddle = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.blue,
    );
    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddle,
      paddleHitBox,
    ]);

    add(
      keyboardListenerComponent = KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            keyEventEnum = KeyEventEnum.down;

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            keyEventEnum = KeyEventEnum.up;

            return true;
          },
        },
        keyUp: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            keyEventEnum = KeyEventEnum.none;

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            // position.y -= speed * deltaTime;
            keyEventEnum = KeyEventEnum.none;

            return true;
          },
        },
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (keyEventEnum == KeyEventEnum.down) {
      final updatedPosition = position.y + speed * dt;
      if (updatedPosition < gameRef.size.y - paddle.height) {
        position.y = updatedPosition;
      }
    }
    if (keyEventEnum == KeyEventEnum.up) {
      final updatedPosition = position.y - speed * dt;
      if (updatedPosition > 0) {
        position.y = updatedPosition;
      }
    }
  }
}
