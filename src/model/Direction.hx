package model;
import flash.geom.Point;

class Direction {
  public var isDownward:Bool;
  public var isRightward:Bool;

  public function new() {
  }

  public function initialize(start:Point, end:Point) {
    this.isRightward = start.x < end.x;
    this.isDownward = start.y < end.y;
  }
}
