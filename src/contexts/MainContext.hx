package contexts;
import dbs.FinderList;
import models.blockbreaker.FinderProp;
import contexts.blockbreaker.FinderContext;
import contexts.blockbreaker.ImageBlockBreakerContext;
import dbs.PlainGame;
import models.blockbreaker.BlockBreakerProp;
import contexts.blockbreaker.PlainBlockBreakerContext;
import configs.Configuration;
import models.ConfigurationProp;
import contexts.test.BallBlockTestContext;
import contexts.menu.TestMenuContext;
import routers.RouteData;
import contexts.test.FeatherTestContext;
import contexts.test.PartsTestContext;
import contexts.test.ShockTestContext;
import contexts.test.ShockHitTestContext;
import contexts.test.BallTestContext;
import contexts.test.BlockHitTestContext;
import contexts.test.SplashTestContext;
import starling.events.Event;
import events.ContextEvent;
import routers.Router;
import models.RouterProp;

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

    ground.addChild(body);
    ground.addChild(menu);
    ground.addChild(god);

    body.name = 'body';
    menu.name = 'menu';
    god.name = 'god';

    if (route != null) {
      go(route);
    }

    this.startAnimation();

    this.addEventListener(ContextEvent.SCENE_CHANGE, function(e:Event) {
      var route:RouteData = cast(e.data, RouteData);
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
      //menu.replace(TestMenuContext, null);
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

    routeMap.set('/bb/finder', function(route:RouteData) {
      menu.replace(TestMenuContext, null);
      body.replace(FinderContext, FinderList.all, route.forceReload);
    });
  }

  public function fromBody(e:Event) {
    trace('body', e);
  }

  public function fromSelf(e:Event) {
    trace('self', e);
  }
}

