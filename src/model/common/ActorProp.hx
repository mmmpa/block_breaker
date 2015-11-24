package model.common;

import config.Def;
using addition.NullOr;

class ActorProp {
  public var w:Int;
  public var h:Int;
  public var padTop:Int;
  public var padSide:Int;
  public var vertical:ActorVertical;
  public var horizontal:ActorHorizontal;

  public function new(?w:Int, ?h:Int, ?padTop:Int, ?padSide:Int, ?horizontal:ActorHorizontal, ?vertical:ActorVertical) {
    this.w = w;
    this.h = h;
    this.padTop = padTop.or(Def.fontSizeNormal >> 1);
    this.padSide = padSide.or(Def.fontSizeNormal);
    this.horizontal = horizontal.or(ActorHorizontal.Left);
    this.vertical = vertical.or(ActorVertical.Middle);
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