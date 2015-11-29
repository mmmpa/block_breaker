package model.common;
import starling.filters.BlurFilter;
import model.common.ActorProp;

using addition.Support;

typedef ButtonPropOption = {
>ActorPropOption,
  var faChar:String;
}

class ButtonProp extends ActorProp {
  public var faChar:String;
  public var color:Int;
  public var bg:Int;
  public var effect:Int;
  public var filter:BlurFilter;

  static public function fa(faChar:String):ButtonProp {
    return new ButtonProp().setFa(faChar);
  }

  public function new(option:ButtonPropOption = null) {
    super(option);
    this.deploy(option, {
      faChar: ''
    }, ['faChar']);
  }

  public function setFa(faChar:String):ButtonProp {
    this.faChar = faChar;
    return this;
  }
}
