package;
import assets.BlockFont;
import flash.text.Font;
import assets.Se;
import assets.Fa;
import events.AppEvent;
import flash.events.Event;
import dbs.Palette;
import configs.Def;
import initializers.FlashState;
import initializers.Scale;
import initializers.Trace;
import configs.Sizing;
import flash.Lib;
import flash.display.Sprite;

using configs.Sizing;
@:meta(SWF(width = '400', height = '800', backgroundColor = '#ffffff', frameRate = '60'))

class Main extends Sprite {
  static public function main():Void {
    Lib.current.stage.addEventListener('started', function(e:AppEvent){
      initialize();
      Game.start(Lib.current.stage);
    }, false, 1, true);
    Lib.current.stage.dispatchEvent(new AppEvent());
  }

  static public function initialize() {
    Palette;
    Def;
    Trace.initialize();
    FlashState.initialize();
    Scale.initialize();
    Se.initialize();
    Fa.initialize();
    BlockFont.initialize();
  }
}


