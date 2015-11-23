package config;
import starling.core.Starling;
import model.common.StrictArea;
import flash.geom.Rectangle;
import db.Palette;
import initializer.Scale;
import starling.display.Stage;
import flash.text.TextFormat;

class Def {
  static public var starling:Starling;
  static public var stage:Stage;
  static public var debug:Bool = true;
  static public var fmt:TextFormat = new TextFormat('_等幅', 20);

  static public var fontSizeNormal:Int = 16;

  static public var splashSize:Int = 16;
  static public var splashFrame:Int = 10;

  static public var cellMargin:Int = 1;

  static public var ballSize:Int = 8;
  static public var ballSize1:Int = 6;
  static public var ballSize2:Int = 4;
  static public var ballSize3:Int = 2;

  static public var ballOffset:Int = 4;
  static public var ballOffset1:Int = 3;
  static public var ballOffset2:Int = 2;
  static public var ballOffset3:Int = 1;

  static public var shockColor:Int = 0x1abc9c;
  static public var shockSize:Int = 100;
  static public var shockThickness:Int = 2;
  static public var shockPower:Float = 0.3;

  static public var dragDistance:Float = 5;

  static public var uiBg:Int = Palette.white;
  static public var uiShadow:Int = Palette.black;
  static public var uiShadowBar:Int = Palette.whiteGrayD;
  static public var testBg:Int = Palette.white;

  static public var area:StrictArea;
  static public var fullArea:StrictArea;

  // 一度にdeactiveするactorの数
  // 画面のフリーズ対策
  static public var deactiveLimit:Int = 10;

  static public var topBarHeight:Int;

  static public function initialize() {
    topBarHeight = Sizing.mm(15);
    area = new StrictArea(0, topBarHeight, sw(), sh() - topBarHeight);
    fullArea = new StrictArea(0, 0, sw(), sh());
  }

  static public function sh():Int {
    return Std.int(stage.stageHeight);
  }

  static public function sw():Int {
    return Std.int(stage.stageWidth);
  }
}