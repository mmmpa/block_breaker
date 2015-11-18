package model;
import flash.geom.Point;
class PlayFieldData {
  public var x:Int;
  public var y:Int;
  public var width:Int;
  public var height:Int;

  public var top:Float;
  public var right:Float;
  public var bottom:Float;
  public var left:Float;

  public function new(x:Int, y:Int, width:Int, height:Int) {
    this.x = x;
    this.y = y;
    this.top = y;
    this.right = x + width;
    this.bottom = y + height;
    this.left = x;
  }

  public function isOutOfBound(p:Point):FieldOutSide {
    if (p.x < left) return FieldOutSide.Left;
    if (p.x > right) return FieldOutSide.Right;
    if (p.y < top) return FieldOutSide.Top;
    if (p.y > bottom) return FieldOutSide.Bottom;

    return FieldOutSide.InField;
  }
}
