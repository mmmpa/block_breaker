package model.common;

import config.Def;
using addition.Support;

typedef ActorPropOption ={
  @:optional var w:Int;
  @:optional var h:Int;
  @:optional var padTop:Int;
  @:optional var padSide:Int;
  @:optional var vertical:ActorVertical;
  @:optional var horizontal:ActorHorizontal;
}

class ActorProp {
  public var w:Int;
  public var h:Int;
  public var padTop:Int;
  public var padSide:Int;
  public var vertical:ActorVertical;
  public var horizontal:ActorHorizontal;

  public function new(option:ActorPropOption = null) {
    this.deploy(option,{
      padTop: Def.fontSizeNormal >> 1,
      padSide: Def.fontSizeNormal,
      horizontal: ActorHorizontal.Left,
      vertical: ActorVertical.Middle
    });
  }
}

enum ActorVertical {
  Top;
  Middle;
  Bottom;
}

enum ActorHorizontal {
  Left;
  Center;
  Right;
}