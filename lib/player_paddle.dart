import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum KeyEventEnum {
  up,
  down,
  none,
}

class PlayerPaddle extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  // PlayerPaddle({});
  late final RectangleHitbox paddleHitBox;
  late final RectangleComponent paddle;

  KeyEventEnum keyPressed = KeyEventEnum.none;
  static const double speed = 400;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad

    final worldRect = gameRef.size.toRect();

    size = Vector2(10, 100);
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
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            keyPressed = KeyEventEnum.down;

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            keyPressed = KeyEventEnum.up;

            return true;
          },
        },
        keyUp: {
          LogicalKeyboardKey.arrowDown: (keysPressed) {
            keyPressed = KeyEventEnum.none;

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            keyPressed = KeyEventEnum.none;

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
    if (keyPressed == KeyEventEnum.down) {
      final updatedPosition = position.y + speed * dt;
      if (updatedPosition < gameRef.size.y - paddle.height) {
        position.y = updatedPosition;
      }
    }
    if (keyPressed == KeyEventEnum.up) {
      final updatedPosition = position.y - speed * dt;
      if (updatedPosition > 0) {
        position.y = updatedPosition;
      }
    }
  }
}
