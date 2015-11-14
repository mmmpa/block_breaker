package ;
import flash.geom.Rectangle;
import starling.core.Starling;
import flash.display.Stage;
import feathers.themes.MinimalMobileTheme;
import starling.display.Sprite;

class Game extends Sprite {
    public function new() {
        super();

        var theme = new MinimalMobileTheme();
    }

    public static function start(stage:Stage):Void {
        stage.frameRate = 60;
        var starling:Starling = new Starling(Game, stage);
        starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        starling.start();
    }
}

