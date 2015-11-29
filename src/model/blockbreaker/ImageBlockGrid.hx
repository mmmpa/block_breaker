package model.blockbreaker;
import model.common.BitmapMapColor;
import config.Def;
import model.common.BitmapMap;
import service.BitmapLoader;

using Lambda;

class ImageBlockGrid {
  private var path:String;
  private var callback:Dynamic;

  public function new(path:String, callback:Dynamic) {
    this.path = path;
    this.callback = callback;
  }

  public function process() {
    BitmapLoader.loadGemaData(path, onLoad);
    return this;
  }

  private function onLoad(data:BitmapMap) {
    var width:Int = Std.int(Def.gameArea.w / data.w);
    var height:Int = width;
    var datas:Array<BlockData> = data.colors.map(function(data:BitmapMapColor){
      if(data == null){
        return null;
      }else{
        return new BlockData(data.color, data.life, data.ball);
      }
    });
    callback(new BlockGrid(data.w, width, height, datas));
  }
}
