package models.common;
import dbs.Palette;
import models.common.ActorProp;

using additions.Support;

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
