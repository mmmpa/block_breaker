package ;
import model.blockbreaker.ImageBlockBreakerProp;
import db.PlainGame;
import model.blockbreaker.BlockBreakerProp;
import router.RouteData;
import config.Def;
import context.MainContext;
import router.Router;
import flash.geom.Rectangle;
import starling.core.Starling;
import flash.display.Stage;
import starling.display.Sprite;

class Game extends Sprite {
  public function new() {
    super();

    var mainRouter:Router = new Router();
    addChild(mainRouter);
    //var route:RouteData = new RouteData('/test/ball', new BallTestProp(3000));
    //var route:RouteData = new RouteData('/test/parts');
    //var route:RouteData = new RouteData('/configuration');
    var route:RouteData = new RouteData('/test/parts');
    //var route:RouteData = new RouteData('/bb/plain', new BlockBreakerProp(PlainGame.plain1()));
    //var route:RouteData = new RouteData('/bb/image', new ImageBlockBreakerProp('asset/octcat.png'), true);
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

