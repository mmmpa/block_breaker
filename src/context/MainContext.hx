package context;
import context.blockbreaker.ImageBlockBreakerContext;
import db.PlainGame;
import model.blockbreaker.BlockBreakerProp;
import context.blockbreaker.PlainBlockBreakerContext;
import config.Configuration;
import model.ConfigurationProp;
import context.test.BallBlockTestContext;
import context.menu.TestMenuContext;
import router.RouteData;
import context.test.FeatherTestContext;
import context.test.PartsTestContext;
import context.test.ShockTestContext;
import context.test.ShockHitTestContext;
import context.test.BallTestContext;
import context.test.BlockHitTestContext;
import context.test.SplashTestContext;
import starling.events.Event;
import event.ContextEvent;
import router.Router;
import model.RouterProp;
import starling.display.Sprite;

class MainContext extends BaseContext {
  private var god:Router;
  private var menu:Router;
  private var body:Router;

  public function new(props:RouterProp, route:RouteData = null) {
    super(props);

    initialize();

    god = new Router(this.router, this);
    menu = new Router(this.router, this);
    body = new Router(this.router, this);

    this.ground.addChild(body);
    this.ground.addChild(menu);
    this.ground.addChild(god);

    if (route != null) {
      go(route);
    }

    this.startAnimation();

    this.addEventListener(ContextEvent.SCENE_CHANGE, function(e:Event) {
      var route:RouteData = e.data;
      go(route);
    });
  }

  private function checkLeak(){
    var timer:Int = 0;
    this.ground.addEventListener(Event.ENTER_FRAME, function(e:Event){
      timer ++;
      if(timer % 10 != 0){
        return;
      }
      dispatchEvent(
        new Event(
        ContextEvent.SCENE_CHANGE,
        false,
        new RouteData('/test/game', new BlockBreakerProp('sa,ple1', PlainGame.plain1()))
        ));
    });
  }

  private function initialize() {
    initializeSetting();
    initializeRouteMap();
  }

  private function initializeSetting() {
    Configuration.initialize();
  }

  private function initializeRouteMap() {
    routeMap.set('/configuration', function(route:RouteData) {
      menu.replace(TestMenuContext, null);

      var configuration:ConfigurationProp = new ConfigurationProp();
      body.replace(ConfigurationContext, configuration);
    });

    routeMap.set('/test/parts', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(PartsTestContext, route.prop);
    });

    routeMap.set('/test/feather', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(FeatherTestContext, route.prop);
    });

    routeMap.set('/test/splash', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(SplashTestContext, route.prop);
    });

    routeMap.set('/test/block/hit', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(BlockHitTestContext, route.prop);
    });

    routeMap.set('/test/ball', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(BallTestContext, route.prop);
    });

    routeMap.set('/test/ball/block', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(BallBlockTestContext, route.prop);
    });

    routeMap.set('/test/shock', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockTestContext, route.prop);
    });

    routeMap.set('/test/shock/hit', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockHitTestContext, route.prop);
    });

    routeMap.set('/bb/plain', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(PlainBlockBreakerContext, route.prop, route.forceReload);
    });

    routeMap.set('/bb/image', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(ImageBlockBreakerContext, route.prop, route.forceReload);
    });
  }

  public function fromBody(e:Event) {
    trace('body', e);
  }

  public function fromSelf(e:Event) {
    trace('self', e);
  }
}

