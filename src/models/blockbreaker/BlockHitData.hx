package models.blockbreaker;
import flash.geom.Point;

class BlockHitData {
  public var block:BlockData;
  public var point:Point;
  public var edgeHit:Bool;
  public var hitSide:BlockHitSide;

  public function new(block:BlockData, point:Point) {
    this.block = block;
    this.point = point;
  }

  public function reset() {
    this.block = null;
    this.point.setTo(-1, -1);
    this.edgeHit = false;
    this.hitSide = null;
  }

  public function hitted():Bool {
    return block != null;
  }

  public function isEdgeHit():Bool {
    return edgeHit;
  }

  public function toString():String {
    return [point.toString(), block.toString()].join(':');
  }
}
