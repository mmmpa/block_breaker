package model;
import view.Block;
import flash.geom.Point;
class BlockHitData {
  public var block:Block;
  public var point:Point;
  public var edgeHit:Bool;

  public function new(block:Block, point:Point) {
    this.block = block;
    this.point = point;
  }

  public function reset() {
    this.block = null;
    this.point.setTo(-1, -1);
    this.edgeHit = false;
  }

  public function hitted():Bool {
    return block != null;
  }

  public function isEdgeHit():Bool {
    return edgeHit;
  }
}
