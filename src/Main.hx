package;
import config.Def;
 import initializer.Scale;
import initializer.Trace;
import config.Sizing;
import haxe.Json;
import flash.Lib;
import flash.display.Sprite;

using config.Sizing;
@:meta(SWF(width = '400', height = '800', backgroundColor = '#ffffff', frameRate = '60'))

class Main extends Sprite {
  static public function main():Void {
    initialize();
    Game.start(Lib.current.stage);
  }

  static public function initialize():Void {
    Trace.initialize();
    Scale.initialize();
  }
}


