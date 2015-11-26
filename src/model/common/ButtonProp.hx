package model.common;
import starling.filters.BlurFilter;
import model.common.ActorProp.ActorHorizontal;

using addition.NullOr;

class ButtonProp extends ActorProp {
  public var faChar:String;
  public var color:Int;
  public var bg:Int;
  public var effect:Int;
  public var filter:BlurFilter;

  public function new(?w:Int, ?h:Int, ?padTop:Int, ?padSide:Int, ?horizontal:ActorHorizontal, ?faChar:String) {
    super(w, h, padTop, padSide, horizontal);
    this.faChar = faChar.or('');
  }
}
