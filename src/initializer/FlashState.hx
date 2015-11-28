package initializer;
import flash.display.Sprite;
import flash.Lib;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Stage;
class FlashState {
  static public function initialize() {
    var stage:Stage = Lib.current.stage;
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    //stage.quality = StageQuality.LOW;

    var main = Lib.current;
    main.mouseEnabled = false;
    main.mouseChildren = main.mouseEnabled = false;
    main.tabChildren = main.tabEnabled = false;
  }
}
