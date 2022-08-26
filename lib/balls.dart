import 'dart:async' as dartAsync;
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
import 'package:pong/scoretext.dart';

class Ball extends CircleComponent
    with HasGameRef<PongGame>, CollisionCallbacks, KeyboardHandler {
  late Vector2 velocity;

  Ball() {
    paint = Paint()..color = Colors.white;
    radius = 10;
  }

  static const double speed = 500;
  static const nudgeSpeed = 300;
  static const degree = math.pi / 180;

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
    position = gameRef.size / 2;
    final spawnAngle = getSpawnAngle;

    final vx = math.cos(spawnAngle * degree) * speed;
    final vy = math.sin(spawnAngle * degree) * speed;
    velocity = Vector2(
      vx,
      vy,
    );
  }

  double get getSpawnAngle {
    final sideToThrow = math.Random().nextBool();

    final random = math.Random().nextDouble();
    final spawnAngle = sideToThrow
        ? lerpDouble(-35, 35, random)!
        : lerpDouble(145, 215, random)!;

    return spawnAngle;
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

    if (other is Wall) {
      final side = other.boundarySide;

      switch (side) {
        case BoundarySide.right:
          final player = gameRef.aiPlayer;
          updatePlayerScore(player);

          break;
        case BoundarySide.left:
          final player = gameRef.player;
          updatePlayerScore(player);
          break;
        case BoundarySide.top:
          velocity.x = velocity.x;
          velocity.y = -velocity.y;
          _playCollisionAudio;
          break;
        case BoundarySide.bottom:
          velocity.x = velocity.x;
          velocity.y = -velocity.y;
          _playCollisionAudio;
          break;
        default:
      }
    }

    if (other is Paddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      velocity = updateBallTrajectory(collisionPoint, paddleRect);
      _playCollisionAudio;
    }

    if (other is AiPaddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      velocity = updateBallTrajectory(collisionPoint, paddleRect);

      _playCollisionAudio;
    }
  }

  void updatePlayerScore(ScoreText player) {
    player.score += 1;
    dartAsync.Timer(const Duration(seconds: 1), () {
      _resetBall;
    });
  }

  Vector2 updateBallTrajectory(Vector2 collisionPoint, Rect paddleRect) {
    Vector2 updatedVelocity = velocity;
    final isLeftHit = collisionPoint.x == paddleRect.left;
    final isRightHit = collisionPoint.x == paddleRect.right;
    final isTopHit = collisionPoint.y == paddleRect.bottom;
    final isBottomHit = collisionPoint.y == paddleRect.top;

    final isLeftOrRight = isLeftHit || isRightHit;
    final isTopOrBottom = isTopHit || isBottomHit;

    if (isLeftOrRight) {
      updatedVelocity.x = -velocity.x;
      updatedVelocity.y = velocity.y + nudgeSpeed;
    }
    if (isTopOrBottom) {
      updatedVelocity.x = velocity.x;
      updatedVelocity.y = -velocity.y;
    }

    return updatedVelocity;
  }
}

void get _playCollisionAudio {
  FlameAudio.play("ball_hit.wav");
}
