package views.common;

import feathers.layout.HorizontalLayout;
import configs.Def;
 import feathers.controls.LayoutGroup;
import starling.display.Quad;
class TopBar extends PartsActor {
  private var bg:Quad;
  private var bar:Quad;
  private var container:LayoutGroup = new LayoutGroup();
  private var layout:HorizontalLayout = new HorizontalLayout();

  public function new() {
    super();

    bg = new Quad(Def.area.w, Def.topBarHeight, Def.uiBg);
    bar = new Quad(Def.area.w, 1, Def.uiShadowBar);
    bar.y = Def.topBarHeight;
    touchable = false;

    // ゲームにおいてfpsが明確に落ちる。
    //var ds:BlurFilter = BlurFilter.createDropShadow(2, Math.PI / 6, Def.uiShadow, 0.3);
    //bg.filter = ds;

    container.layout = layout;
    addChild(bg);
    addChild(bar);
    addChild(container);
    flatten();
  }
}
