package ;
import addition.Def;
import starling.events.Event;
import event.ContextEvent;
import context.MainContext;
import router.Router;
import flash.geom.Rectangle;
import starling.core.Starling;
import flash.display.Stage;
import feathers.themes.MinimalMobileTheme;
import starling.display.Sprite;

class Game extends Sprite {
  public function new() {
    super();

    var theme = new MinimalMobileTheme();
    var router:Router = new Router();
    addChild(router);
    router.push(MainContext, {route: '/test/shock/hit'});
  }

  public static function start(stage:Stage):Void {
    stage.frameRate = 60;
    var starling:Starling = new Starling(Game, stage);
    Def.stage = starling.stage;
    starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
    starling.start();
  }
}

