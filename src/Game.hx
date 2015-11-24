package ;
import model.test.BallTestProp;
import starling.utils.VAlign;
import starling.utils.HAlign;
import router.RouteData;
import config.Def;
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
    var mainRouter:Router = new Router();
    addChild(mainRouter);
    //var route:RouteData = new RouteData('/test/ball', new BallTestProp(3000));
    //var route:RouteData = new RouteData('/test/parts');
    var route:RouteData = new RouteData('/configuration');
    mainRouter.pushRoot(MainContext, route);
  }

  public static function start(stage:Stage):Void {
    stage.frameRate = 60;
    var starling:Starling = new Starling(Game, stage);
    Def.stage = starling.stage;
    Def.starling = starling;
    starling.enableErrorChecking = false;
    starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
    starling.start();
  }
}

