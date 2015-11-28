package context.menu;
import view.common.PresetButton;
import model.blockbreaker.ImageBlockBreakerProp;
import db.PlainGame;
import model.blockbreaker.BlockBreakerProp;
import model.common.ActorProp;
import model.common.ButtonProp;
import view.common.TopBar;
import config.Def;
import model.test.BallTestProp;
import view.common.Button;
import view.common.SideMenu;
import asset.Fa;
import router.RouteData;
import model.RouterProp;

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
    trace('button');
    menu = new SideMenu(routesSrc);
    trace('button');
    var faButton:Button = PresetButton.normal('', new ButtonProp({
      w: Def.topBarHeight,
      h: Def.topBarHeight,
      horizontal: ActorHorizontal.Center,
      faChar: Fa.char.bars
    }), function() {
      menu.open();
    });
trace('button');
    beOnStage(bar);
    beOnStage(menu);
    beOnStage(faButton);
  }

  override public function deactivate() {
    super.deactivate();
  }

  private function get_routesSrc():Array<MenuRecipe> {
    return [
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
        text: 'stage Finder',
        route: new RouteData('/bb/finder')
      }
    ];
  }
}
