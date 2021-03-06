package contexts.menu;
import events.SideMenuEvent;
import configs.OnAir;
import views.common.PresetButton;
import models.common.ActorProp;
import models.common.ButtonProp;
import views.common.TopBar;
import configs.Def;
import models.test.BallTestProp;
import views.common.Button;
import views.common.SideMenu;
import routers.SceneChangeData;
import models.RouterProp;

using Lambda;

class TestMenuContext extends BaseContext {
  private var routes:Array<SceneChangeData>;
  private var routesSrc(get, never):Array<MenuRecipe>;
  private var menu:SideMenu;
  private var bar:TopBar;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();

    bar = new TopBar();
    menu = new SideMenu({
      menuRecipes: routesSrc,
      openedCallback: function() {
        emit(SideMenuEvent.newOpened());
      },
      closedCallback: function() {
        emit(SideMenuEvent.newClosed());
      }
    });

    var faButton:Button = PresetButton.normal({
      text: '',
      prop: new ButtonProp({
        w: Def.topBarHeight,
        h: Def.topBarHeight,
        horizontal: ActorHorizontal.Center,
        char: Reorder
      }),
      callback: function() {
        menu.open();
      }
    });
    addActor(bar);
    addActor(menu);
    addActor(faButton);
  }

  override public function deactivate() {
    super.deactivate();
  }

  private function get_routesSrc():Array<MenuRecipe> {
    var base:Array<MenuRecipe> = [
      {
        icon: Cog2,
        text: 'configration',
        route: new SceneChangeData('/configuration')
      },
      {
        icon: Cogs3,
        text: 'test: parts',
        route: new SceneChangeData('/test/parts')
      },
      {
        icon: Spinner8,
        text: 'test: splash animation',
        route: new SceneChangeData('/test/splash')
      },
      {
        icon: Lightning14,
        text: 'test: block refrection',
        route: new SceneChangeData('/test/block/hit')
      },
      {
        icon: Circle33,
        text: 'shock wave test',
        route: new SceneChangeData('/test/shock')
      },
      {
        icon: Lightning14,
        text: 'shock wave refrection test',
        route: new SceneChangeData('/test/shock/hit')
      },
      {
        icon: Tint,
        text: 'test: only ball 1000',
        route: new SceneChangeData('/test/ball', new BallTestProp(1000))
      },
      {
        icon: Tint,
        text: 'test: only ball 2500',
        route: new SceneChangeData('/test/ball', new BallTestProp(2500))
      },
      {
        icon: Tint,
        text: 'test: only ball 5000',
        route: new SceneChangeData('/test/ball', new BallTestProp(5000))
      },
      {
        icon: Square62,
        text: 'test: block ball 1000',
        route: new SceneChangeData('/test/ball/block', new BallTestProp(1000))
      },
      {
        icon: Square62,
        text: 'test: block ball 1500',
        route: new SceneChangeData('/test/ball/block', new BallTestProp(1500))
      },
      {
        icon: Square62,
        text: 'test: block ball 2000',
        route: new SceneChangeData('/test/ball/block', new BallTestProp(2000))
      },
      {
        icon: Four29,
        text: 'stage finder',
        route: new SceneChangeData('/bb/finder')
      }
    ];

    if (OnAir.enable) {
      base.push({
        icon: Four29,
        text: 'exit',
        route: new SceneChangeData('/app/exit')
      });
    }

    return base;
  }
}
