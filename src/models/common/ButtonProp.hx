package models.common;
import starling.filters.BlurFilter;
import models.common.ActorProp;

using additions.Support;

typedef ButtonPropOption = {
>ActorPropOption,
  @:optional var char:Dynamic;
}

class ButtonProp extends ActorProp {
  public var char:Class<Dynamic>;
  public var color:Int;
  public var bg:Int;
  public var effect:Int;
  public var filter:BlurFilter;

  static public function fa(char):ButtonProp {
    return new ButtonProp().setFa(char);
  }

  public function new(option:ButtonPropOption = null) {
    super(option);
    this.deploy(option, {
      char: null
    }, ['char']);
  }

  public function setFa(char):ButtonProp {
    this.char = char;
    return this;
  }
}
