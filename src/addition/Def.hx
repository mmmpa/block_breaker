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

  static public var ballSize:Int = 4;

  static public var shockColor:Int = 0xffcc00;
  static public var shockSize:Int = 100;
  static public var shockThickness:Int = 2;
  static public var shockPower:Float = 0.3;
}
