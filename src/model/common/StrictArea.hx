package model.common;
class StrictArea {
  public var x:Int;
  public var y:Int;
  public var w:Int;
  public var h:Int;

  public function new(x:Float, y:Float, w:Float, h:Float) {
    this.x = Std.int(x);
    this.y = Std.int(y);
    this.w = Std.int(w);
    this.h = Std.int(h);
  }
}
