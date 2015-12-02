package configs;
import models.blockbreaker.PlayFieldData;
import starling.filters.BlurFilter;
import starling.core.Starling;
import models.common.StrictArea;
import dbs.Palette;
import starling.display.Stage;

class Def {
  // このサイズを基準としてパーツの縮尺を決める。
  static public var baseWidth:Int = 480;
  static public var baseHeight:Int = 800;

  // 環境を保持する
  static public var starling:Starling;
  static public var stage:Stage;
  static public var rawStage:flash.display.Stage;
  static public var stageWidth:Int;
  static public var stageHeight:Int;
  static public var debug:Bool = true;

  // 環境によって変化が生じない値
  // 特に数値
  static public var tapHoldCount:Int = 30;
  static public var splashFrame:Int = 10;
  static public var cellMargin:Int = 1;
  static public var shockColor:Int = 0x1abc9c;
  static public var shockPower:Float = 0.3;
  // 一度にdeactiveするactorの数。画面のフリーズ対策
  static public var deactivationAmoutOnce:Int = 10;
  // カラー関係
  static public var uiBg:Int = Palette.white;
  static public var uiLine:Int = Palette.whiteGray;
  static public var uiShadow:Int = Palette.black;
  static public var uiShadowBar:Int = Palette.whiteGrayD;
  static public var testBg:Int = Palette.white;
  static public var deadBg:Int = Palette.black;


  // dpiから算出
  static public var fontSizeNormal:Int;
  static public var fontSizeBig:Int;
  static public var paddingTop:Int;
  static public var paddingSide:Int;
  static public var topBarHeight:Int;

  // 元のピクセル数と実際のピクセル数との倍率で変更。
  static public var baseRate:Float;
  static public var splashSize:Int = 16;
  static public var ballSize:Int = 8;
  static public var ballSize1:Int = 6;
  static public var ballSize2:Int = 4;
  static public var ballSize3:Int = 2;
  static public var ballOffset:Int = 4;
  static public var ballOffset1:Int = 3;
  static public var ballOffset2:Int = 2;
  static public var ballOffset3:Int = 1;
  static public var shockSize:Int = 100;
  static public var shockThickness:Int = 2;
  static public var dragDistance:Float = 5;
  static public var ballSpeedNormal:Int = 10;

  // 上部で決定された数値から計算
  static public var fullArea:StrictArea;
  static public var area:StrictArea;
  static public var gameArea:StrictArea;
  static public var gameField:PlayFieldData;
  static public var ballStartTop:Float;
  static public var innerWidth:Int;
  static public var innerHeight:Int;
  static public var innerMinHeight:Int;
  static public var innerPadding:Int;


  // starling起動後でないと設定できない
  static public var uiDs:BlurFilter;

  static public function initialize() {
    setBaseValue();
    detectBaseRate();
    detectPixel();
    detectMm();

    fullArea = new StrictArea(0, 0, stageWidth, stageHeight);
    area = new StrictArea(0, topBarHeight, fullArea.w, fullArea.h - topBarHeight);
    gameArea = new StrictArea(0, topBarHeight, baseWidth * baseRate, baseHeight * baseRate - topBarHeight);
    gameField = new PlayFieldData(0, 0, gameArea.w, gameArea.h);

    innerWidth = Std.int(area.w / 1.618);
    innerMinHeight = Std.int(innerWidth / 1.618);
    innerPadding = Std.int(area.w - innerWidth / 2);
    innerHeight = Std.int(area.h - (area.w - innerWidth));

    ballStartTop = gameArea.h - 100 * baseRate;

    uiDs = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, uiShadow, 0.5);
  }

  static public function setBaseValue() {
    stageWidth = stage.stageWidth;
    stageHeight = stage.stageHeight;
  }

  static public function detectBaseRate() {
    var w:Float = stageWidth / baseWidth;
    var h:Float = stageHeight / baseHeight;

    baseRate = w < h ? w : h;
  }

  static public function detectPixel() {
    splashSize = Std.int(splashSize * baseRate);
    ballSize = Std.int(ballSize * baseRate);
    ballSize1 = Std.int(ballSize1 * baseRate);
    ballSize2 = Std.int(ballSize2 * baseRate);
    ballSize3 = Std.int(ballSize3 * baseRate);
    ballOffset = ballSize >> 1;
    ballOffset1 = ballSize1 >> 1;
    ballOffset2 = ballSize2 >> 1;
    ballOffset3 = ballSize3 >> 3;
    shockSize = Std.int(shockSize * baseRate);
    shockThickness = Std.int(shockThickness * baseRate);
    dragDistance = Std.int(dragDistance * baseRate);
    ballSpeedNormal = Std.int(ballSpeedNormal * baseRate);
  }

  static public function detectMm() {
    topBarHeight = Sizing.mm(6);
    fontSizeNormal = Sizing.mm(3);
    fontSizeBig = Sizing.mm(5);
    paddingTop = Sizing.mm(3);
    paddingSide = Sizing.mm(3);
  }

  static public function sh():Int {
    return Std.int(stage.stageHeight);
  }

  static public function sw():Int {
    return Std.int(stage.stageWidth);
  }

}
