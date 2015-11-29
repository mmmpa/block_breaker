package model.common;
import db.Palette;
import model.common.ActorProp;

using addition.Support;

typedef CheckboxPropOption = {
>ActorPropOption,
  @:optional var position:ActorHorizontal;
  @:optional var checkedColor:Int;
  @:optional var uncheckedColor:Int;
}

class CheckboxProp extends ActorProp {
  public var position:ActorHorizontal;
  public var checkedColor:Int;
  public var uncheckedColor:Int;

  public function new(option:CheckboxPropOption = null) {
    super(option);
    this.deploy(option, {
      position: ActorHorizontal.Left,
      checkedColor: Palette.black,
      uncheckedColor: Palette.black
    }, ['position', 'checkedColor', 'uncheckedColor']);
  }
}
