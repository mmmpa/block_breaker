package addition;
import starling.display.Stage;
import flash.text.TextFormat;
class Def {
  static public var stage:Stage;
  static public var debug:Bool = true;
  static public var fmt:TextFormat = new TextFormat('_等幅', 20);

  static public var splashSize:Int = 16;
  static public var splashFrame:Int = 10;

  static public var cellMargin:Int = 1;

  static public var ballSize:Int = 8;
  static public var ballSize1:Int = 6;
  static public var ballSize2:Int = 4;
  static public var ballSize3:Int = 2;

  static public var ballOffset:Int = 4;
  static public var ballOffset1:Int = 1;
  static public var ballOffset2:Int = 1;
  static public var ballOffset3:Int = 1;

  static public var shockColor:Int = 0x1abc9c;
  static public var shockSize:Int = 100;
  static public var shockThickness:Int = 2;
  static public var shockPower:Float = 0.3;
}
