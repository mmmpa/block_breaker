package model.common;
class BitmapMap {
  public var w:Int;
  public var h:Int;
  public var colors:Array<BitmapMapColor> = new Array();

  public function new(w:Int, h:Int, colors:Array<BitmapMapColor>) {
    this.w = w;
    this.h = h;
    this.colors = colors;
  }
}
