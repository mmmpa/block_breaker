package model.common;
import starling.filters.BlurFilter;
import model.common.ActorProp.ActorHorizontal;

using addition.Support;

class ButtonProp extends ActorProp {
  public var faChar:String;
  public var color:Int;
  public var bg:Int;
  public var effect:Int;
  public var filter:BlurFilter;

  static public function fa(faChar:String):ButtonProp {
    return new ButtonProp().setFa(faChar);
  }

  public function new(?w:Int, ?h:Int, ?padTop:Int, ?padSide:Int, ?horizontal:ActorHorizontal, ?faChar:String) {
    super(w, h, padTop, padSide, horizontal);
    this.faChar = faChar.or('');
  }

  public function setFa(faChar:String):ButtonProp {
    this.faChar = faChar;
    return this;
  }
}
