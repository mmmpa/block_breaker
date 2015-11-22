package context.menu;
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

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();
    menu = new SideMenu(routesSrc);
    var faButton:Button = Button.normal(function(){
      menu.open();
    }, null, '', Fa.char.apple);
    beOnStage(menu);
    beOnStage(faButton);
  }

  private function get_routesSrc():Array<MenuRecipe> {
    return [
      {
        icon: Fa.char.cogs,
        text: 'test: parts',
        route: new RouteData('/test/parts')
      },
      {
        icon: Fa.char.fire,
        text: 'test: feathers',
        route: new RouteData('/test/feather')
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
        text: 'test: ball only 1000',
        route: new RouteData('/test/ball', new BallTestProp(1000))
      },
      {
        icon: Fa.char.tint,
        text: 'test: ball only 2500',
        route: new RouteData('/test/ball', new BallTestProp(2500))
      },
      {
        icon: Fa.char.tint,
        text: 'test: ball only 5000',
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
        text: 'sample game',
        route: new RouteData('/test/game')
      }
    ];
  }
}
