package db;
import model.BlockData;
import addition.Def;
import model.BlockGrid;

using Lambda;

class PlainGame {
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

  public static function plain1():BlockGrid {
    var colors:Array<Int> = [-1, -1, grayD, grayD, redD, red, orangeD, orange, yellowD, yellow, greenD, green, blueD, blue, purpleD, purple];

    var col:Int = 20;
    var width:Int = Std.int(Def.stage.stageWidth / col);
    var height:Int = width >> 1;
    var datas:Array<BlockData> = new Array();
    colors.iter(function(color) {
      for (i in 0...col) {
        if (color == -1) {
          datas.push(null);
        } else {
          if(color == yellow || color == red || color == purple || color == redD || color == orangeD || color == orange || color == yellowD || color == redD  ){
            datas.push(new BlockData(color, 1, 1));
          }else if(color == blue){
            datas.push(new BlockData(color, 2, 1));
          }else{
            datas.push(new BlockData(color, 1, 0));
          }
        }
      }
    });

    return new BlockGrid(col, width, height, datas);
  }
}
