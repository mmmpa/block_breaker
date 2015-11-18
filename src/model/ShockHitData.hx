package model;
import flash.geom.Point;
class ShockHitData {
  public var hit:Point;
  public var next:Point;
  public var point:Point;

  public function new(hit:Point, next:Point) {
    this.hit = hit;
    this.next = next;
    this.point = hit;
  }
}
