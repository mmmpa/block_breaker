package context;
import model.test.BallTestProp;
import config.Configuration;
import config.Def;
 import db.ConfigStore;
import model.ConfigurationProp;
import context.test.BallBlockTestContext;
import context.menu.TestMenuContext;
import router.RouteData;
import context.test.FeatherTestContext;
import context.test.PartsTestContext;
import context.test.SampleGameContext;
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
import starling.text.TextField;

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
      trace(route);
      go(route.route, route.prop);
    }

    this.startAnimation();
    this.addEventListener(ContextEvent.SCENE_CHANGE, function(e:Event) {
      var route:RouteData = e.data;
      go(route.route, route.prop);
    });

    /*
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
        new RouteData('/test/ball/block', new BallTestProp(1000))
        ));
    });*/
  }

  private function initialize() {
    initializeSetting();
    initializeRouteMap();
  }

  private function initializeSetting() {
    Def.initialize();
    Configuration.initialize();
  }

  private function initializeRouteMap() {
    routeMap.set('/', function(insertProps) {
      god.push(GodContext, insertProps);
      menu.replace(MenuContext, null);
      body.replace(BodyContext, insertProps);
    });

    routeMap.set('/configuration', function(insertProps) {
      menu.replace(TestMenuContext, null);

      var configuration:ConfigurationProp = new ConfigurationProp();
      body.replace(ConfigurationContext, insertProps);
    });

    routeMap.set('/test/parts', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(PartsTestContext, insertProps);
    });

    routeMap.set('/test/feather', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(FeatherTestContext, insertProps);
    });

    routeMap.set('/test/splash', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(SplashTestContext, insertProps);
    });

    routeMap.set('/test/block/hit', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(BlockHitTestContext, insertProps);
    });

    routeMap.set('/test/ball', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(BallTestContext, insertProps);
    });

    routeMap.set('/test/ball/block', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(BallBlockTestContext, insertProps);
    });

    routeMap.set('/test/shock', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockTestContext, insertProps);
    });

    routeMap.set('/test/shock/hit', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockHitTestContext, insertProps);
    });

    routeMap.set('/test/game', function(insertProps) {
      menu.replace(TestMenuContext, null);
      body.replace(SampleGameContext, insertProps);
    });
  }

  public function fromBody(e:Event) {
    trace('body', e);
  }

  public function fromSelf(e:Event) {
    trace('self', e);
  }
}

