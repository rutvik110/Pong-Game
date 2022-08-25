import 'dart:async' as dartAsync;
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/services.dart';
import 'package:pong/ai_paddle.dart';
import 'package:pong/boundaries.dart';
import 'package:pong/player_bar.dart';

class Ball extends CircleComponent
    with HasGameRef<FlameGame>, CollisionCallbacks, KeyboardHandler {
  late Paint originalPaint;
  bool giveNudge = false;

  Vector2 velocity;
  final double _timeSinceNudge = 0.0;
  static const double _minNudgeRest = 2.0;

  Ball(this.velocity) {
    originalPaint = randomPaint();
    paint = originalPaint;

    radius = 10;
  }

  Paint randomPaint() => PaintExtension.random(withAlpha: 0.9, base: 100);
  //late final MoveToEffect effect;

  @override
  Future<void>? onLoad() {
    _resetBall;
    final hitBox = CircleHitbox(
      radius: radius,
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

  void get _resetBall {
    final sideToThrow = math.Random().nextBool();
    position = gameRef.size / 2;
    final random = math.Random().nextDouble();
    const degree = math.pi / 180;
    final angle = sideToThrow
        ? lerpDouble(-35, 35, random)!
        : lerpDouble(145, 215, random)!;
    //math.Random().nextDouble() * math.pi * 2;
    final vx = math.cos(angle * degree) * 500;
    final vy = math.sin(angle * degree) * 500;
    velocity = Vector2(
      vx,
      vy,
    );
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
    final collisionPoint = intersectionPoints.toList()[0];
    double vx = velocity.x;
    double vy = velocity.y;

    if (other is Wall) {
      final side = other.boundarySide;

      switch (side) {
        case BoundarySide.right:
          final timer = dartAsync.Timer(const Duration(seconds: 1), () {
            _resetBall;
          });

          break;
        case BoundarySide.left:
          final timer = dartAsync.Timer(const Duration(seconds: 1), () {
            _resetBall;
          });

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

    // log(collisionPoint.y.toString());

    if (other is Paddle) {
      final paddleRect = other.paddle.toAbsoluteRect();
      final isSide = (collisionPoint.x >= paddleRect.left &&
          collisionPoint.x <= paddleRect.right);
      final isUpBottom = (collisionPoint.y > other.paddle.y &&
          collisionPoint.y < other.paddle.y + paddleRect.height);
      final isLeftOrRight = isSide && !isUpBottom;
      if (isLeftOrRight) {
        vx = -velocity.x;
        vy = velocity.y;
      } else {
        vx = velocity.x;
        vy = -velocity.y;
      }
    }

    if (other is AiPaddle) {
      final paddleRect = other.paddle.toAbsoluteRect();
      final isSide = (collisionPoint.x >= paddleRect.left &&
          collisionPoint.x <= paddleRect.right);
      final isUpBottom = (collisionPoint.y > other.paddle.y &&
          collisionPoint.y < other.paddle.y + paddleRect.height);
      final isLeftOrRight = isSide && !isUpBottom;
      if (isLeftOrRight) {
        vx = -velocity.x;
        vy = velocity.y;
      } else {
        vx = velocity.x;
        vy = -velocity.y;
      }
    }

    velocity = Vector2(vx, vy);
  }
}
