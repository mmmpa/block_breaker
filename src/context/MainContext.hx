package context;
import context.test.ShockTestContext;
import context.test.ShockHitTestContext;
import context.test.BallTestContext;
import context.test.BlockHitTestContext;
import context.test.BlockTestContext;
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

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);

    initialize();

    god = new Router(this.router);
    menu = new Router(this.router);
    body = new Router(this.router);

    this.view.addChild(god);
    this.view.addChild(menu);
    this.view.addChild(body);

    if (insertProps != null) {
      go(insertProps.route, insertProps);
    }
  }

  private function initialize() {
    initializeRouteMap();
  }

  private function initializeRouteMap() {
    routeMap.set('/', function(insertProps) {
      god.push(GodContext, insertProps);
      menu.push(MenuContext, insertProps);
      body.push(BodyContext, insertProps);
    });

    routeMap.set('/test/splash', function(insertProps) {
      body.push(SplashTestContext, insertProps);
    });
    routeMap.set('/test/block', function(insertProps) {
      body.push(BlockTestContext, insertProps);
    });
    routeMap.set('/test/block/hit', function(insertProps) {
      body.push(BlockHitTestContext, insertProps);
    });

    routeMap.set('/test/ball', function(insertProps) {
      body.push(BallTestContext, insertProps);
    });

    routeMap.set('/test/shock', function(insertProps) {
      body.push(ShockTestContext, insertProps);
    });

    routeMap.set('/test/shock/hit', function(insertProps) {
      body.push(ShockHitTestContext, insertProps);
    });
  }

  public function fromBody(e:Event) {
    trace('body', e);
  }

  public function fromSelf(e:Event) {
    trace('self', e);
  }
}

