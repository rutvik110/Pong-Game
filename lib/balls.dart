import 'dart:async' as dartAsync;
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pong/ai_paddle.dart';
import 'package:pong/boundaries.dart';
import 'package:pong/main.dart';
import 'package:pong/player_bar.dart';

class Ball extends CircleComponent
    with HasGameRef<PongGame>, CollisionCallbacks, KeyboardHandler {
  late Paint originalPaint;
  bool giveNudge = false;

  Vector2 velocity;

  Ball(this.velocity) {
    originalPaint = Paint()..color = Colors.white;
    paint = originalPaint;

    radius = 10;
  }

  static const double speed = 500;
  static const nudgeSpeed = 300;

  @override
  Future<void>? onLoad() {
    _resetBall;
    final hitBox = CircleHitbox(
      radius: radius,
    );

    addAll([
      hitBox,
    ]);

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

    final vx = math.cos(angle * degree) * speed;
    final vy = math.sin(angle * degree) * speed;
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
          final player = gameRef.aiPlayer;
          player.score += 1;
          final timer = dartAsync.Timer(const Duration(seconds: 1), () {
            _resetBall;
          });

          break;
        case BoundarySide.left:
          final player = gameRef.player;
          player.score += 1;
          final timer = dartAsync.Timer(const Duration(seconds: 1), () {
            _resetBall;
          });

          break;
        case BoundarySide.top:
          vx = velocity.x;
          vy = -velocity.y;
          FlameAudio.play("ball_hit.wav");
          break;
        case BoundarySide.bottom:
          vx = velocity.x;
          vy = -velocity.y;
          FlameAudio.play("ball_hit.wav");
          break;
        default:
      }
    }

    if (other is Paddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      final isLeftHit = collisionPoint.x == paddleRect.left;
      final isRightHit = collisionPoint.x == paddleRect.right;
      final isTopHit = collisionPoint.y == paddleRect.bottom;
      final isBottomHit = collisionPoint.y == paddleRect.top;

      final isLeftOrRight = isLeftHit || isRightHit;
      final isTopOrBottom = isTopHit || isBottomHit;

      if (isLeftOrRight) {
        vx = -velocity.x;

        vy = velocity.y + nudgeSpeed;
        log(vy.toString());
        log(vy.toString());
      }
      if (isTopOrBottom) {
        vx = velocity.x;
        vy = -velocity.y;
      }
      FlameAudio.play("ball_hit.wav");
    }

    if (other is AiPaddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      final isLeftHit = collisionPoint.x == paddleRect.left;
      final isRightHit = collisionPoint.x == paddleRect.right;
      final isTopHit = collisionPoint.y == paddleRect.bottom;
      final isBottomHit = collisionPoint.y == paddleRect.top;

      final isLeftOrRight = isLeftHit || isRightHit;
      final isTopOrBottom = isTopHit || isBottomHit;

      if (isLeftOrRight) {
        vx = -velocity.x;
        vy = velocity.y + nudgeSpeed;
      }
      if (isTopOrBottom) {
        vx = velocity.x;
        vy = -velocity.y;
      }
      FlameAudio.play("ball_hit.wav");
    }

    velocity = Vector2(vx, vy);
  }
}
