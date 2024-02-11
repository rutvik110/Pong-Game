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

class PlayerPaddle extends RectangleComponent with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  // PlayerPaddle({});
  late final RectangleHitbox paddleHitBox;

  KeyEventEnum keyPressed = KeyEventEnum.none;
  static const double speed = 400;

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad

    final worldRect = gameRef.size.toRect();

    size = Vector2(10, 100);
    position.x = worldRect.width * 0.9 - 10;
    position.y = worldRect.height / 2 - size.y / 2;
    paint = Paint()..color = Colors.blue;
    paddleHitBox = RectangleHitbox(
      size: size,
    );

    addAll([
      paddleHitBox,
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    if (keyPressed == KeyEventEnum.down) {
      final updatedPosition = position.y + speed * dt;
      if (updatedPosition < gameRef.size.y - height) {
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

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        keyPressed = KeyEventEnum.down;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        keyPressed = KeyEventEnum.up;
      }
    }

    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        keyPressed = KeyEventEnum.none;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        keyPressed = KeyEventEnum.none;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
