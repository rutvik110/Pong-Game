import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

enum BoundarySide {
  top,
  bottom,
  left,
  right,
}

List<Wall> createBoundaries(FlameGame game) {
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
  final BoundarySide boundarySide;
  final bool isSensor;

  Wall({
    required this.boundarySide,
    this.isSensor = false,
  });

  @override
  Future<void>? onLoad() {
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
}

Vector2 getSidePosition(FlameGame game, BoundarySide side) {
  switch (side) {
    case BoundarySide.top:
      return Vector2(0, 0);
      break;
    case BoundarySide.bottom:
      return Vector2(0, game.size.y - 5);
      break;
    case BoundarySide.left:
      return Vector2(0, 0);
      break;
    case BoundarySide.right:
      return Vector2(game.size.x - 1, 0);
      break;
    default:
      return Vector2(0, 0);
  }
}

Vector2 getSideSize(FlameGame game, BoundarySide side) {
  switch (side) {
    case BoundarySide.top:
      return Vector2(game.size.x, 5);
      break;
    case BoundarySide.bottom:
      return Vector2(game.size.x, 5);
      break;
    case BoundarySide.left:
      return Vector2(1, game.size.y);
      break;
    case BoundarySide.right:
      return Vector2(1, game.size.y);
      break;
    default:
      return Vector2(0, 0);
  }
}
