import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pong/player_bar.dart';

enum BoundarySide {
  top,
  bottom,
  left,
  right,
}

List<Wall> createBoundaries(FlameGame game) {
  final topLeft = Vector2.zero();
  final bottomRight = Vector2(game.size.x, game.size.y);
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(
      boundarySide: BoundarySide.top,
    ),
    Wall(
      boundarySide: BoundarySide.right,
      isSensor: true,
    ),
    Wall(
      boundarySide: BoundarySide.bottom,
    ),
    Wall(
      boundarySide: BoundarySide.left,
      isSensor: true,
    ),
  ];
}

class Wall extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  // final Vector2 start;
  // final Vector2 end;
  final BoundarySide boundarySide;
  final bool isSensor;

  Wall({
    // required this.start,
    // required this.end,
    required this.boundarySide,
    this.isSensor = false,
  });

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad

    final hitBox = RectangleHitbox(
      position: getSidePosition(
        gameRef,
        boundarySide,
      ),
      size: getSideSize(
        gameRef,
        boundarySide,
      ),
    );

    final rectangleComponent = RectangleComponent(
      position: getSidePosition(
        gameRef,
        boundarySide,
      ),
      size: getSideSize(
        gameRef,
        boundarySide,
      ),
      paint: Paint()..color = Colors.white,
    );

    addAll([
      hitBox,
      rectangleComponent,
    ]);
    return super.onLoad();
  }

  // @override
  // Body createBody() {
  //   late final EdgeShape shape;
  //   late final FixtureDef fixtureDef;
  //   late final BodyDef bodyDef;

  //   shape = EdgeShape()..set(start, end);
  //   fixtureDef = FixtureDef(
  //     shape,
  //     friction: 0.3,
  //     isSensor: isSensor,
  //   );
  //   bodyDef = BodyDef(
  //     userData: this, // To be able to determine object in collision
  //     position: Vector2.zero(),
  //   );

  //   return world.createBody(bodyDef)..createFixture(fixtureDef);
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is Paddle) {
      log("Paddle Toched");
    }
    super.onCollision(intersectionPoints, other);
  }
}

// List<Wall> createBoundaries(FlameGame game) {
//   final topLeft = Vector2.zero();
//   final bottomRight = Vector2(game.size.x, game.size.y);
//   final topRight = Vector2(bottomRight.x, topLeft.y);
//   final bottomLeft = Vector2(topLeft.x, bottomRight.y);

//   return [
//     Wall(
//       start: topLeft,
//       end: topRight,
//       boundarySide: BoundarySide.top,
//       boundarySize: getSideSize(game, BoundarySide.top),
//       boundaryPosition: getSidePosition(game, BoundarySide.top),
//     ),
//     Wall(
//       start: topRight,
//       end: bottomRight,
//       boundarySide: BoundarySide.right,
//       boundarySize: getSideSize(game, BoundarySide.right),
//       boundaryPosition: getSidePosition(game, BoundarySide.right),
//       isSensor: false,
//     ),
//     Wall(
//       start: bottomRight,
//       end: bottomLeft,
//       boundarySide: BoundarySide.bottom,
//       boundarySize: getSideSize(game, BoundarySide.bottom),
//       boundaryPosition: getSidePosition(game, BoundarySide.bottom),
//     ),
//     Wall(
//       start: bottomLeft,
//       end: topLeft,
//       boundarySide: BoundarySide.left,
//       boundarySize: getSideSize(game, BoundarySide.left),
//       boundaryPosition: getSidePosition(game, BoundarySide.left),
//       isSensor: false,
//     ),
//   ];
// }

// class Wall extends PositionComponent
//     with HasGameRef<FlameGame>, CollisionCallbacks {
//   final Vector2 start;
//   final Vector2 end;
//   final BoundarySide boundarySide;
//   final bool isSensor;
//   final Vector2 boundaryPosition;
//   final Vector2 boundarySize;

//   Wall({
//     required this.start,
//     required this.end,
//     required this.boundarySide,
//     required this.boundarySize,
//     required this.boundaryPosition,
//     this.isSensor = false,
//   });

//   @override
//   Future<void>? onLoad() {
//     // TODO: implement onLoad
//     size = boundarySize;
//     position = boundaryPosition;
//     final hitBox = RectangleHitbox(
//       position: position,
//       size: size,
//     );

//     log(gameRef.size.toString());

//     addAll([
//       hitBox,
//       RectangleComponent(
//         size: size,
//         position: position,
//         paint: Paint()..color = Colors.white,
//       ),
//     ]);
//     return super.onLoad();
//   }
// }

Vector2 getSidePosition(FlameGame game, BoundarySide side) {
  switch (side) {
    case BoundarySide.top:
      return Vector2(0, 0);
      break;
    case BoundarySide.bottom:
      return Vector2(0, game.size.y - 10);
      break;
    case BoundarySide.left:
      return Vector2(0, 0);
      break;
    case BoundarySide.right:
      return Vector2(game.size.x - 10, 0);
      break;
    default:
      return Vector2(0, 0);
  }
}

Vector2 getSideSize(FlameGame game, BoundarySide side) {
  switch (side) {
    case BoundarySide.top:
      return Vector2(game.size.x, 10);
      break;
    case BoundarySide.bottom:
      return Vector2(game.size.x, 10);
      break;
    case BoundarySide.left:
      return Vector2(10, game.size.y);
      break;
    case BoundarySide.right:
      return Vector2(10, game.size.y);
      break;
    default:
      return Vector2(0, 0);
  }
}
