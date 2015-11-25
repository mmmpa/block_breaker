package service;
import model.common.BitmapMapColor;
import model.common.BitmapMap;
import flash.display.BitmapData;
import flash.system.LoaderContext;
import flash.net.URLRequest;
import flash.events.Event;
import flash.display.Loader;

class BitmapLoader {
  public static function load(path:String, callback:Dynamic) {
    var loader:Loader = new Loader();
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) {
      var data:BitmapData = e.target.content.bitmapData;
      var colors:Array<BitmapMapColor> = new Array();
      for (ii in 0...data.height) {
        for (i in 0...data.width) {
          var src:Int = data.getPixel32(i, ii);
          var alpha:Int = Math.round((src >> 24 & 0xFF) / 2.55);
          if (alpha == 0) {
            colors.push(null);
          } else {
            var color:Int = src & 0xffffff;
            if(alpha == 100){
              colors.push(new BitmapMapColor(color));
            }else{
              var base:Int = Std.int(alpha / 10);
              var life:Int = 10 - base;
              var ball:Int = alpha - base * 10;
              colors.push(new BitmapMapColor(color, life, ball));
            }
          }
        }
      }
      callback(new BitmapMap(data.width, data.height, colors));
    });
    loader.load(new URLRequest(path), new LoaderContext(true));
  }
}
