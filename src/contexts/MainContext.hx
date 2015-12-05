package contexts;
import starling.events.Event;
import events.SideMenuEvent;
import models.RouterProp;
import events.ContextCreatedEvent;
import configs.OnAir;
import dbs.FinderList;
import models.blockbreaker.FinderProp;
import contexts.blockbreaker.FinderContext;
import contexts.blockbreaker.ImageBlockBreakerContext;
import contexts.blockbreaker.PlainBlockBreakerContext;
import configs.Configuration;
import models.ConfigurationProp;
import contexts.test.BallBlockTestContext;
import contexts.menu.TestMenuContext;
import routers.SceneChangeData;
import contexts.test.PartsTestContext;
import contexts.test.ShockTestContext;
import contexts.test.ShockHitTestContext;
import contexts.test.BallTestContext;
import contexts.test.BlockHitTestContext;
import contexts.test.SplashTestContext;
import routers.Router;

class MainContext extends BaseContext {
  private var god:Router;
  private var menu:Router;
  private var body:Router;

  public function new(props:RouterProp, scene:SceneChangeData = null) {
    super(props);

    initialize();

    god = Router.asChild(router, this);
    menu = Router.asChild(router, this);
    body = Router.asChild(router, this);

    addChild(body);
    addChild(menu);
    addChild(god);

    startAnimation();

    addEventListener(ContextCreatedEvent.CREATED, function(e:ContextCreatedEvent) {
      if (e.forMe(that) && scene != null) {
        go(scene);
      }
    });
    addEventListener(SideMenuEvent.OPENED, function(e:SideMenuEvent) {
      broadcast(new Event('pause'));
    });
    addEventListener(SideMenuEvent.CLOSED, function(e:SideMenuEvent) {
      broadcast(new Event('resume'));
    });
  }

  private function initialize() {
    initializeSetting();
    initializeSceneMap();
  }

  private function initializeSetting() {
    Configuration.initialize();
  }

  private function initializeSceneMap() {
    registerScene('/configuration', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);

      var configuration:ConfigurationProp = new ConfigurationProp();
      body.replace(ConfigurationContext, configuration);
    });

    registerScene('/test/parts', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(PartsTestContext, scene.prop);
    });

    registerScene('/test/splash', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(SplashTestContext, scene.prop);
    });

    registerScene('/test/block/hit', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(BlockHitTestContext, scene.prop);
    });

    registerScene('/test/ball', function(scene:SceneChangeData) {
      //menu.replace(TestMenuContext, null);
      body.replace(BallTestContext, scene.prop);
    });

    registerScene('/test/ball/block', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(BallBlockTestContext, scene.prop);
    });

    registerScene('/test/shock', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockTestContext, scene.prop);
    });

    registerScene('/test/shock/hit', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(ShockHitTestContext, scene.prop);
    });

    registerScene('/bb/plain', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(PlainBlockBreakerContext, scene.prop, scene.forceReload);
    });

    registerScene('/bb/image', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(ImageBlockBreakerContext, scene.prop, scene.forceReload);
    });

    registerScene('/bb/finder', function(scene:SceneChangeData) {
      menu.replace(TestMenuContext, null);
      body.replace(FinderContext, FinderList.all, scene.forceReload);
    });

    registerScene('/app/exit', function(scene:SceneChangeData) {
      OnAir.exit();
    });
  }
}

