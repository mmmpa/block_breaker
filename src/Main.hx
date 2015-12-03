package;
import assets.BlockFont;
import assets.Se;
import events.AppEvent;
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
    Trace.initialize();
    FlashState.initialize();
    Scale.initialize();
    Se.initialize();
    BlockFont.initialize();
  }
}


