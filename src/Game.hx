package ;
import models.blockbreaker.ImageBlockBreakerProp;
import models.test.BallTestProp;
import starling.display.Sprite;
import routers.RouteData;
import configs.Def;
import contexts.MainContext;
import routers.Router;
import flash.geom.Rectangle;
import starling.core.Starling;
import flash.display.Stage;

class Game extends Sprite {
  public function new() {
    super();
    //touchable = false;
    var mainRouter:Router = new Router();
    addChild(mainRouter);
    mainRouter.name = 'mainRouter';

    //var route:RouteData = new RouteData('/test/ball', new BallTestProp(5000));
    //var route:RouteData = new RouteData('/test/parts');
    var route:RouteData = new RouteData('/configuration');
    //var route:RouteData = new RouteData('/test/parts');
    //var route:RouteData = new RouteData('/bb/plain', new BlockBreakerProp(PlainGame.plain1()));
    var route:RouteData = new RouteData('/bb/finder');
    var route:RouteData = new RouteData('/bb/image', new ImageBlockBreakerProp('kobito', 'asset/kobito.png'), true);
    //var route:RouteData = new RouteData('/test/ball/block', new BallTestProp(1000));
    mainRouter.pushRoot(MainContext, route);
  }

  public static function start(stage:Stage):Void {
    stage.frameRate = 60;
    var starling:Starling = new Starling(Game, stage);
    Def.stage = starling.stage;
    Def.starling = starling;
    Def.initialize();
    starling.enableErrorChecking = false;
    starling.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
    starling.start();
  }
}

