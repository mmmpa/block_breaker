package config;
import flash.display.BitmapData;
import flash.display.GradientType;
import starling.textures.Texture;
import starling.core.Starling;
import model.common.StrictArea;
import db.Palette;
import starling.display.Stage;
import flash.text.TextFormat;

class Def {
  static public var starling:Starling;
  static public var stage:Stage;
  static public var debug:Bool = true;
  static public var fmt:TextFormat = new TextFormat('_等幅', 20);

  static public var tapHoldCount:Int = 30;

  static public var splashSize:Int = 16;
  static public var splashFrame:Int = 10;

  static public var cellMargin:Int = 0;

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
  static public var uiLine:Int = Palette.whiteGray;
  static public var uiShadow:Int = Palette.black;
  static public var uiShadowBar:Int = Palette.whiteGrayD;
  static public var testBg:Int = Palette.white;

  // 一度にdeactiveするactorの数
  // 画面のフリーズ対策
  static public var deactiveLimit:Int = 10;

  // 起動後に決定される
  static public var area:StrictArea;
  static public var fullArea:StrictArea;
  static public var ballStartTop:Float;
  static public var innerWidth:Int;
  static public var innerHeight:Int;
  static public var innerMinHeight:Int;
  static public var innerPadding:Int;

  // 計算により決定
  static public var fontSizeNormal:Int;
  static public var paddingTop:Int;
  static public var paddingSide:Int;
  static public var topBarHeight:Int;

  static public function initialize() {
    topBarHeight = Sizing.mm(15);
    fontSizeNormal = Sizing.mm(8);
    paddingTop = Sizing.mm(4);
    paddingSide = Sizing.mm(8);
    area = new StrictArea(0, topBarHeight, sw(), sh() - topBarHeight);
    innerWidth = Std.int(area.w / 1.618);
    innerMinHeight = Std.int(innerWidth / 1.618);
    innerPadding = Std.int(area.w - innerWidth / 2);
    innerHeight = Std.int(area.h - (area.w - innerWidth));
    fullArea = new StrictArea(0, 0, sw(), sh());
    ballStartTop = area.h - 100;
  }

  static public function sh():Int {
    return Std.int(stage.stageHeight);
  }

  static public function sw():Int {
    return Std.int(stage.stageWidth);
  }

}
