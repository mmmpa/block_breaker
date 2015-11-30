package dbs;
import dbs.Palette;
import models.blockbreaker.BlockData;
import configs.Def;
 import models.blockbreaker.BlockGrid;

using Lambda;

class PlainGame {

  public static function plain1():BlockGrid {
    var colors:Array<Int> = [-1, -1, Palette.grayD, Palette.grayD, Palette.redD, Palette.red, Palette.orangeD, Palette.orange, Palette.yellowD, Palette.yellow, Palette.greenD, Palette.green, Palette.blueD, Palette.blue, Palette.purpleD, Palette.purple];

    var col:Int = 20;
    var width:Int = Std.int(Def.area.w / col);
    var height:Int = width >> 1;
    var datas:Array<BlockData> = new Array();
    colors.iter(function(color) {
      for (i in 0...col) {
        if (color == -1) {
          datas.push(null);
        } else {
          if(color == Palette.yellow || color == Palette.red || color == Palette.purple || color == Palette.redD || color == Palette.orangeD || color == Palette.orange || color == Palette.yellowD || color == Palette.redD  ){
            datas.push(new BlockData(color, 1, 1));
          }else if(color == Palette.blue){
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
