package context.menu;
import event.ContextEvent;
import starling.events.Event;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import asset.Fa;
import router.RouteData;
import model.RouterProp;
import view.common.Button;

using Lambda;

typedef TestMenuRecipe = {icon:String, text:String, route:RouteData}

class TestMenuContext extends BaseContext {
  private var routes:Array<RouteData>;
  private var routesSrc(get, never):Array<TestMenuRecipe>;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();

    var layout:VerticalLayout = new VerticalLayout();

    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    ground.addChild(container);

    var that = this;
    makeButtons().iter(function(button:Button){
      button.activate(that, container);
    });
  }

  private function makeButtons():Array<Button>{
    return routesSrc.map(function(recipe:TestMenuRecipe):Button{
      return Button.normal(function(){
        emit(new Event(ContextEvent.SCENE_CHANGE, false, recipe.route));
      }, null, recipe.text, recipe.icon);
    });
  }

  private function get_routesSrc():Array<TestMenuRecipe> {
    return [
      {
        icon: Fa.char.cogs,
        text: 'パーツテスト',
        route: new RouteData('/test/parts')
      },
      {
        icon: Fa.char.fire,
        text: 'feathers動作テスト',
        route: new RouteData('/test/feather')
      },
      {
        icon: Fa.char.spinner,
        text: 'ブロック破壊エフェクトテスト',
        route: new RouteData('/test/splash')
      },
      {
        icon: Fa.char.square,
        text: 'ブロックテスト',
        route: new RouteData('/test/block')
      },
      {
        icon: Fa.char.lineChart,
        text: 'ブロック衝突テスト',
        route: new RouteData('/test/block/hit')
      },
      {
        icon: Fa.char.tint,
        text: 'ボールテスト',
        route: new RouteData('/test/ball')
      },
      {
        icon: Fa.char.circleONotch,
        text: '衝撃波テスト',
        route: new RouteData('/test/shock')
      },
      {
        icon: Fa.char.lineChart,
        text: '衝撃波衝突テスト',
        route: new RouteData('/test/shock/hit')
      },
      {
        icon: Fa.char.th,
        text: 'サンプルゲーム',
        route: new RouteData('/test/game')
      }
    ];
  }
}
