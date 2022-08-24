import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/boundaries.dart';
import 'package:pong/player_bar.dart';

class Ball extends CircleComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  late Paint originalPaint;
  bool giveNudge = false;

  Vector2 velocity;
  // final double _timeSinceNudge = 0.0;
  // static const double _minNudgeRest = 2.0;

  Ball(this.velocity) {
    originalPaint = randomPaint();
    paint = originalPaint;
    position = Vector2(100, 100);
    radius = 50;
  }

  Paint randomPaint() => PaintExtension.random(withAlpha: 0.9, base: 100);
  late final CircleComponent ball;
  //late final MoveToEffect effect;

  @override
  Future<void>? onLoad() {
    final hitBox = CircleHitbox(
      radius: radius,
      position: Vector2.zero(),
    );

    addAll([
      hitBox,
      // ball,
    ]);
    add(
      KeyboardListenerComponent(
        keyDown: {
          // LogicalKeyboardKey.arrowDown: (keysPressed) {
          //   position += Vector2(0, 5);

          //   return true;
          // },
          // LogicalKeyboardKey.arrowUp: (keysPressed) {
          //   position += Vector2(0, -5);

          //   return true;
          // },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            position += Vector2(-5, 0);

            return true;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            position += Vector2(5, 0);

            return true;
          },
        },
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    //calculate the next point of position based on
    // the intersection point and speed vector
    // final ballVelocity = velocity;
    // final impactNormal = Vector2(1, -2);

    // final dotProduct =
    //     ballVelocity.x * impactNormal.x + ballVelocity.y * impactNormal.y;
    final collisionPoint = intersectionPoints.toList()[0];
    late final double vx;
    late final double vy;

    if (other is Wall) {
      final side = other.boundarySide;

      switch (side) {
        case BoundarySide.right:
          vx = -velocity.x;
          vy = velocity.y;
          break;
        case BoundarySide.left:
          vx = -velocity.x;
          vy = velocity.y;
          break;
        case BoundarySide.top:
          vx = velocity.x;
          vy = -velocity.y;
          break;
        case BoundarySide.bottom:
          vx = velocity.x;
          vy = -velocity.y;
          break;
        default:
      }
    }

    if (other is Paddle) {
      final paddleRect = other.paddle.toRect();
      final isLeftOrRight = (collisionPoint.x >= paddleRect.left &&
              collisionPoint.x <= paddleRect.right) &&
          !(collisionPoint.y > paddleRect.top &&
              collisionPoint.y < paddleRect.bottom);
      // final isTopOrBottom = collisionPoint.y >= paddleRect.top ||
      //     collisionPoint.y <= paddleRect.top + paddleRect.height;

      // final isTopOrBottom = collisionPoint.x >= paddleRect.top &&
      //     collisionPoint.x <= paddleRect.top + paddleRect.width;

      if (isLeftOrRight) {
        log("Left/Right + ${collisionPoint.toString()}");
        vx = -velocity.x;
        vy = velocity.y;
      } else {
        log("Top/Bottom + ${collisionPoint.toString()}");

        vx = velocity.x;
        vy = -velocity.y;
      }
    }

    velocity = Vector2(vx, vy);
  }

  // @override
  // Body createBody() {
  //   final shape = CircleShape();
  //   shape.radius = radius;

  //   final fixtureDef = FixtureDef(
  //     shape,
  //     restitution: 0.8,
  //     density: 1.0,
  //     friction: 0.4,
  //   );

  //   final bodyDef = BodyDef(
  //     userData: this,
  //     angularDamping: 0.8,
  //     position: Vector2(10, 10),
  //     type: BodyType.dynamic,
  //   );

  //   final fixture = world.createBody(bodyDef)..createFixture(fixtureDef);

  //   fixture.applyLinearImpulse(Vector2(0, 50));

  //   return fixture;
  // }

  // @override
  // void beginContact(Object other, Contact contact) {
  //   if (other is Wall) {
  //     other.paint = paint;
  //   }

  //   // if (other is WhiteBall) {
  //   //   return;
  //   // }

  //   if (other is Ball) {
  //     if (paint != originalPaint) {
  //       paint = other.paint;
  //     } else {
  //       other.paint = paint;
  //     }
  //   }
  // }
}
