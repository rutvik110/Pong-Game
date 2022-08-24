import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Paddle extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  // Paddle({});
  late final RectangleHitbox paddleHitBox;
  late final RectangleComponent paddle;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad
    final worldRect = gameRef.size.toRect();
    log(worldRect.center.toString());
    final size = Vector2(50, 200);
    final center = Vector2(worldRect.center.dx, worldRect.center.dy);
    paddle = RectangleComponent(
        position: center, size: size, paint: Paint()..color = Colors.white);
    paddleHitBox = RectangleHitbox(
      position: center,
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
            position += Vector2(0, 50);

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            position += Vector2(0, -50);

            return true;
          },
        },
      ),
    );
    return super.onLoad();
  }
}




// class Bar extends BodyComponent
//     with ContactCallbacks, KeyboardHandler, Tappable {
//   late Vector2 barPosition;

//   @override
//   Body createBody() {
//     barPosition = Vector2(10, 20);
//     final bar = PolygonShape()..setAsBoxXY(2, 5);

//     final fixtureDef = FixtureDef(
//       bar,
//       restitution: 1,
//       density: 1.0,
//       friction: 0,
//     );

//     final bodyDef = BodyDef(
//       userData: this,
//       position: Vector2(10, 20),
//       type: BodyType.static,
//     );
//     add(
//       KeyboardListenerComponent(keyDown: {
//         LogicalKeyboardKey.arrowUp: (keysPressed) {
//           body. = Vector2(0, -10);

//           return true;
//         },
//         LogicalKeyboardKey.arrowDown: (keysPressed) {
//           body.linearVelocity = Vector2(0, 10);
//           return true;
//         },
//         LogicalKeyboardKey.keyW: (keysPressed) {
//           return true;
//         },
//         LogicalKeyboardKey.keyS: (keysPressed) {
//           return true;
//         },
//       }, keyUp: {
//         LogicalKeyboardKey.arrowUp: (keysPressed) {
//           body.linearVelocity = Vector2(0, 0);

//           return true;
//         },
//         LogicalKeyboardKey.arrowDown: (keysPressed) {
//           body.linearVelocity = Vector2(0, 0);
//           return true;
//         },
//       }),
//     );
//     final fixture = world.createBody(bodyDef)..createFixture(fixtureDef);
//     return fixture;
//   }

//   @override
//   void update(double dt) {
//     // TODO: implement update
//     super.update(dt);
//     //  body.applyLinearImpulse(-Vector2(0, 10.0));
//   }
// }
