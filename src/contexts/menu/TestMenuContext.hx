package contexts.menu;
import views.common.PresetButton;
import models.blockbreaker.ImageBlockBreakerProp;
import dbs.PlainGame;
import models.blockbreaker.BlockBreakerProp;
import models.common.ActorProp;
import models.common.ButtonProp;
import views.common.TopBar;
import configs.Def;
import models.test.BallTestProp;
import views.common.Button;
import views.common.SideMenu;
import assets.Fa;
import routers.RouteData;
import models.RouterProp;

using Lambda;

class TestMenuContext extends BaseContext {
  private var routes:Array<RouteData>;
  private var routesSrc(get, never):Array<MenuRecipe>;
  private var menu:SideMenu;
  private var bar:TopBar;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();

    bar = new TopBar();
    menu = new SideMenu(routesSrc);
    var faButton:Button = PresetButton.normal({
      text: '',
      prop: new ButtonProp({
        w: Def.topBarHeight,
        h: Def.topBarHeight,
        horizontal: ActorHorizontal.Center,
        faChar: Fa.char.bars
      }),
      callback: function() {
        menu.open();
      }
    });
    beOnStage(bar);
    beOnStage(menu);
    beOnStage(faButton);
  }

  override public function deactivate() {
    super.deactivate();
  }

  private function get_routesSrc():Array<MenuRecipe> {
    var base:Array<MenuRecipe> = [
      {
        icon: Fa.char.cog,
        text: 'configration',
        route: new RouteData('/configuration')
      },
      {
        icon: Fa.char.cogs,
        text: 'test: parts',
        route: new RouteData('/test/parts')
      },
      {
        icon: Fa.char.spinner,
        text: 'test: splash animation',
        route: new RouteData('/test/splash')
      },
      {
        icon: Fa.char.lineChart,
        text: 'test: block refrection',
        route: new RouteData('/test/block/hit')
      },
      {
        icon: Fa.char.circleONotch,
        text: 'shock wave test',
        route: new RouteData('/test/shock')
      },
      {
        icon: Fa.char.lineChart,
        text: 'shock wave refrection test',
        route: new RouteData('/test/shock/hit')
      },
      {
        icon: Fa.char.tint,
        text: 'test: only ball 1000',
        route: new RouteData('/test/ball', new BallTestProp(1000))
      },
      {
        icon: Fa.char.tint,
        text: 'test: only ball 2500',
        route: new RouteData('/test/ball', new BallTestProp(2500))
      },
      {
        icon: Fa.char.tint,
        text: 'test: only ball 5000',
        route: new RouteData('/test/ball', new BallTestProp(5000))
      },
      {
        icon: Fa.char.square,
        text: 'test: block ball 1000',
        route: new RouteData('/test/ball/block', new BallTestProp(1000))
      },
      {
        icon: Fa.char.square,
        text: 'test: block ball 1500',
        route: new RouteData('/test/ball/block', new BallTestProp(1500))
      },
      {
        icon: Fa.char.square,
        text: 'test: block ball 2000',
        route: new RouteData('/test/ball/block', new BallTestProp(2000))
      },
      {
        icon: Fa.char.th,
        text: 'stage finder',
        route: new RouteData('/bb/finder')
      }
    ];

    trace(Def.appController);
    if(Def.appController != null){
      base.push({
        icon: Fa.char.th,
        text: 'exit',
        route: new RouteData('/app/exit')
      });
    }

    return base;
  }
}
