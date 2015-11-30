package initializers;
import configs.Def;
import flash.display.StageQuality;
import flash.Lib;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Stage;
class FlashState {
  static public function initialize() {
    var stage:Stage = Lib.current.stage;
    Def.rawStage = stage;
    stage.align = StageAlign.TOP_LEFT;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.quality = StageQuality.LOW;

    var main = Lib.current;
    main.mouseChildren = main.mouseEnabled = false;
    main.tabChildren = main.tabEnabled = false;
  }
}
