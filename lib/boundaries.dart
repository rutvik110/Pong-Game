import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
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
    Wall(topLeft, topRight, BoundarySide.top),
    Wall(
      topRight,
      bottomRight,
      BoundarySide.right,
      true,
    ),
    Wall(bottomRight, bottomLeft, BoundarySide.bottom),
    Wall(
      bottomLeft,
      topLeft,
      BoundarySide.left,
      true,
    ),
  ];
}

class Wall extends PositionComponent
    with HasGameRef<FlameGame>, CollisionCallbacks {
  final Vector2 start;
  final Vector2 end;
  final BoundarySide boundarySide;
  final bool isSensor;

  Wall(
    this.start,
    this.end,
    this.boundarySide, [
    this.isSensor = false,
  ]);

  @override
  Future<void>? onLoad() {
    // TODO: implement onLoad

    final hitBox = RectangleHitbox(position: borderPosition, size: borderSize);

    add(hitBox);
    return super.onLoad();
  }

  Vector2 get borderPosition {
    switch (boundarySide) {
      case BoundarySide.top:
        return Vector2(0, 0);
        break;
      case BoundarySide.bottom:
        return Vector2(0, gameRef.size.y - 1);
        break;
      case BoundarySide.left:
        return Vector2(0, 0);
        break;
      case BoundarySide.right:
        return Vector2(gameRef.size.x - 1, 0);
        break;
      default:
        return Vector2(0, 0);
    }
  }

  Vector2 get borderSize {
    switch (boundarySide) {
      case BoundarySide.top:
        return Vector2(gameRef.size.x, 1);
        break;
      case BoundarySide.bottom:
        return Vector2(gameRef.size.x, 1);
        break;
      case BoundarySide.left:
        return Vector2(1, gameRef.size.y);
        break;
      case BoundarySide.right:
        return Vector2(1, gameRef.size.y);
        break;
      default:
        return Vector2(0, 0);
    }
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
