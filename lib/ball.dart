import 'dart:async' as dartAsync;
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pong/ai_paddle.dart';
import 'package:pong/main.dart';
import 'package:pong/player_paddle.dart';
import 'package:pong/scoretext.dart';

/*
 -lib/
   |---main.dart
   |---pong_game.dart
   |---player_paddle.dart
   |---ball.dart
   |---ai_paddle.dart
   |---scoretext.dart
*/
class Ball extends CircleComponent
    with HasGameRef<PongGame>, CollisionCallbacks {
  Ball() {
    paint = Paint()..color = Colors.white;
    radius = 10;
  }

  static const double speed = 500;
  late Vector2 velocity;
  static const degree = math.pi / 180;
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
  @mustCallSuper
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    final collisionPoint = intersectionPoints.first;

    if (other is ScreenHitbox) {
      // Left Side Collision
      if (collisionPoint.x == 0) {
        final player = gameRef.player;
        updateScore(player);
      }
      // Right Side Collision
      if (collisionPoint.x == gameRef.size.x) {
        final player = gameRef.aiPlayer;
        updateScore(player);
      }
      // Top Side Collision
      if (collisionPoint.y == 0) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
        _playCollisionAudio;
      }
      // Bottom Side Collision
      if (collisionPoint.y == gameRef.size.y) {
        velocity.x = velocity.x;
        velocity.y = -velocity.y;
        _playCollisionAudio;
      }
    }

    if (other is PlayerPaddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);
      _playCollisionAudio;
    }

    if (other is AIPaddle) {
      final paddleRect = other.paddle.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);

      _playCollisionAudio;
    }
  }

  void updateScore(ScoreText player) {
    player.score += 1;
    dartAsync.Timer(const Duration(seconds: 1), () {
      _resetBall;
    });
  }

  void updateBallTrajectory(Vector2 collisionPoint, Rect paddleRect) {
    final isLeftHit = collisionPoint.x == paddleRect.left;
    final isRightHit = collisionPoint.x == paddleRect.right;
    final isTopHit = collisionPoint.y == paddleRect.bottom;
    final isBottomHit = collisionPoint.y == paddleRect.top;

    final isLeftOrRight = isLeftHit || isRightHit;
    final isTopOrBottom = isTopHit || isBottomHit;

    if (isLeftOrRight) {
      velocity.x = -velocity.x;
      velocity.y = velocity.y + nudgeSpeed;
    }
    if (isTopOrBottom) {
      velocity.x = velocity.x;
      velocity.y = -velocity.y + nudgeSpeed;
    }
  }
}

void get _playCollisionAudio {
  FlameAudio.play("ball_hit.wav");
}

// @override
//   void update(double dt) {
//     super.update(dt);
//     position += velocity * dt;

//     if (giveNudge) {
//       if (_timeSinceNudge <= 3) {
//         nudgedVelocity = lerpDouble(nudgeSpeed, 0, _timeSinceNudge)! * dt;

//         // velocity += nudgedVelocity;

//         // final addedVelocity = lerpDouble(800, 0, _timeSinceNudge)! * dt;

//         velocity.y += nudgedVelocity;
//         velocity.x += nudgedVelocity;
//         _timeSinceNudge + dt;
//       } else {
//         nudgedVelocity = 0;
//         _timeSinceNudge = 0;
//         giveNudge = false;
//       }
//     } else {
//       nudgedVelocity = 0;
//     }
//   }
