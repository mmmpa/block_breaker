package db;
class Palette {
  static public var darkBlue:Int = 0x34495e;
  static public var darkBlueD:Int = 0x2c3e50;
  static public var purple:Int = 0x9b59b6;
  static public var purpleD:Int = 0x8e44ad;
  static public var blue:Int = 0x3498db;
  static public var blueD:Int = 0x2980b9;
  static public var green:Int = 0x40d47e;
  static public var greenD:Int = 0x27ae60;
  static public var blueGreen:Int = 0x1abc9c;
  static public var blueGreenD:Int = 0x16a085;
  static public var yellow:Int = 0xf1c40f;
  static public var yellowD:Int = 0xf39c12;
  static public var orange:Int = 0xe67e22;
  static public var orangeD:Int = 0xd35400;
  static public var red:Int = 0xe74c3c;
  static public var redD:Int = 0xc0392b;
  static public var whiteGray:Int = 0xecf0f1;
  static public var whiteGrayD:Int = 0xbdc3c7;
  static public var gray:Int = 0x95a5a6;
  static public var grayD:Int = 0x7f8c8d;
  static public var white:Int = 0xffffff;
  static public var black:Int = 0;
  static public var fontBlack:Int = 0x333333;
  static public var all:Array<Int> = [
    darkBlue,
    darkBlueD,
    purple,
    purpleD,
    blue,
    blueD,
    green,
    greenD,
    blueGreen,
    blueGreenD,
    yellow,
    yellowD,
    orange,
    orangeD,
    red,
    redD,
    whiteGray,
    whiteGrayD,
    gray,
    grayD,
    white,
    black,
    fontBlack
  ];

  static public function random() {
    return all[Std.int(Math.floor(Math.random() * all.length))];
  }
}
