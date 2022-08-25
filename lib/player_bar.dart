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
  double deltaTime = 0;

  static const double speed = 400;

  late final KeyboardListenerComponent keyboardListenerComponent;
  KeyEventEnum keyEventEnum = KeyEventEnum.none;

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad
    final worldRect = gameRef.size.toRect();

    final size = Vector2(10, 100);
    // position = Vector2(200, 200);
    position.x = worldRect.width * 0.9;
    paddle =
        RectangleComponent(size: size, paint: Paint()..color = Colors.white);
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
            // position.y += speed * deltaTime;
            keyEventEnum = KeyEventEnum.down;

            return true;
          },
          LogicalKeyboardKey.arrowUp: (keysPressed) {
            // position.y -= speed * deltaTime;
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
    deltaTime = dt;
    if (keyEventEnum == KeyEventEnum.down) {
      position.y += speed * deltaTime;
    }
    if (keyEventEnum == KeyEventEnum.up) {
      position.y -= speed * deltaTime;
    }
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
