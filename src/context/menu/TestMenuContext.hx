package context.menu;
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
      trace('push');
      menu.open();
    }, null, '', Fa.char.apple);
    beOnStage(menu);
    beOnStage(faButton);
  }

  private function get_routesSrc():Array<MenuRecipe> {
    return [
      {
        icon: Fa.char.cogs,
        text: 'parts test',
        route: new RouteData('/test/parts')
      },
      {
        icon: Fa.char.fire,
        text: 'feathers動作テスト',
        route: new RouteData('/test/feather')
      },
      {
        icon: Fa.char.spinner,
        text: 'splash test',
        route: new RouteData('/test/splash')
      },
      {
        icon: Fa.char.square,
        text: 'block test',
        route: new RouteData('/test/block')
      },
      {
        icon: Fa.char.lineChart,
        text: 'block refrection test',
        route: new RouteData('/test/block/hit')
      },
      {
        icon: Fa.char.tint,
        text: 'ball test',
        route: new RouteData('/test/ball')
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
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      },
      {
        icon: Fa.char.th,
        text: 'sample game',
        route: new RouteData('/test/game')
      }
    ];
  }
}
