package model.common;

using addition.NullOr;

class ButtonProp {
  public var width:Int;
  public var height:Int;
  public var paddingTop:Int;
  public var paddingSide:Int;

  public function new(?width:Int, ?height:Int, ?paddingTop:Int, ?paddingSide:Int) {
    this.width = width;
    this.height = height;
    this.paddingTop = paddingTop.or(10);
    this.paddingSide = paddingSide.or(20);
  }

}
