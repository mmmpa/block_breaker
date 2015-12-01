package services;
import models.common.BitmapMapColor;
import models.common.BitmapMap;
import flash.display.BitmapData;
import flash.system.LoaderContext;
import flash.net.URLRequest;
import flash.events.Event;
import flash.display.Loader;

class BitmapLoader {
  static public var store:Map<String, BitmapData> = new Map();

  static public function analyse(data:BitmapData):Array<BitmapMapColor> {
    var colors:Array<BitmapMapColor> = new Array();
    for (ii in 0...data.height) {
      for (i in 0...data.width) {
        var src:Int = data.getPixel32(i, ii);
        var alpha:Int = Math.round((src >> 24 & 0xFF) / 2.55);
        if (alpha == 0) {
          colors.push(null);
        } else {
          var color:Int = src & 0xffffff;
          if (alpha == 100) {
            colors.push(new BitmapMapColor(color));
          } else {
            var base:Int = Std.int(alpha / 10);
            var life:Int = 10 - base;
            var ball:Int = alpha - base * 10;
            colors.push(new BitmapMapColor(color, life, ball));
          }
        }
      }
    }
    return colors;
  }

  static public function load(path:String, callback:Dynamic) {
    if (store.get(path) == null) {
      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event) {
        var data:BitmapData = e.target.content.bitmapData;
        callback(data);
      });
      loader.load(new URLRequest(path), new LoaderContext(true));
    } else {
      var data:BitmapData = store.get(path);
      callback(data);
    }
  }

  static public function loadGemaData(path:String, callback:Dynamic) {
    load(path, function(data:BitmapData){
      callback(new BitmapMap(data.width, data.height, analyse(data)));
    });
  }
}

