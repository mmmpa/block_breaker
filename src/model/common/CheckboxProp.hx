package model.common;
import model.common.ActorProp.ActorHorizontal;
class CheckboxProp extends ActorProp {
  public var position:ActorHorizontal;
  public var checkedColor:Int;
  public var uncheckedColor:Int;

  public function new(checkedColor:Int, uncheckedColor:Int, position:ActorHorizontal) {
    super();
    this.checkedColor = checkedColor;
    this.uncheckedColor = uncheckedColor;
    this.position = position;
  }
}

