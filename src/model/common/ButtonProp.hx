package model.common;

using addition.NullOr;

class ButtonProp {
  public var width:Int;
  public var height:Int;
  public var paddingTop:Int;
  public var paddingSide:Int;
  public var align:ButtonAlign;
  public var faChar:String;
  public var color:Int;
  public var effect:Int;

  public function new(?width:Int, ?height:Int, ?paddingTop:Int, ?paddingSide:Int, ?align:ButtonAlign, ?faChar:String) {
    this.width = width;
    this.height = height;
    this.paddingTop = paddingTop.or(10);
    this.paddingSide = paddingSide.or(20);
    this.align = align.or(ButtonAlign.Left);
    this.faChar = faChar.or('');
  }
}

enum ButtonAlign {
  Left;
  Center;
  Right;
}