import 'dart:developer';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pong/balls.dart';

enum BoundarySide {
  top,
  bottom,
  left,
  right,
}

List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft = Vector2.zero();
  final bottomRight = game.screenToWorld(game.camera.viewport.effectiveSize);
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

class Wall extends BodyComponent with ContactCallbacks {
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
  Body createBody() {
    late final EdgeShape shape;
    late final FixtureDef fixtureDef;
    late final BodyDef bodyDef;

    shape = EdgeShape()..set(start, end);
    fixtureDef = FixtureDef(
      shape,
      friction: 0.3,
      isSensor: isSensor,
    );
    bodyDef = BodyDef(
      userData: this, // To be able to determine object in collision
      position: Vector2.zero(),
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    // TODO: implement beginContact
    super.beginContact(other, contact);
    if (other is Ball) {
      //check which boundary i'm colliding with
      if (isSensor) {
        log("Ball Escaped");
        other.removeFromParent();
      } else {
        other.giveNudge = false;
      }
    }
  }
}
