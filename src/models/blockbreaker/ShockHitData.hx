package models.blockbreaker;
import flash.geom.Point;
class ShockHitData {
  public var id:Int;
  public var next:Point;
  public var point:Point;
  public var radian:Float;

  public function new(point:Point, next:Point) {
    this.next = next;
    this.point = point;
  }
}
