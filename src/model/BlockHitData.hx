package model;
import view.Block;
import flash.geom.Point;
class BlockHitData {
  public var block:Block;
  public var point:Point;

  public function new(block:Block, point:Point) {
    this.block = block;
    this.point = point;
  }
}
