package context.test;
import starling.display.DisplayObjectContainer;
import config.Def;
 import feathers.layout.VerticalLayout;
import feathers.controls.ScrollContainer;
import asset.Fa;
import view.common.FaIcon;
import model.RouterProp;

using Lambda;

class FeatherTestContext extends BaseContext {
  private var manualDisposer:Array<Dynamic> = new Array();
  private var manualRemover:Array<DisplayObjectContainer> = new Array();

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;
    startAnimation();

    var container:ScrollContainer = new ScrollContainer();
    container.width = Def.area.w;
    container.height = Def.area.h;
    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.padding = 0;
    container.layout = layout;
    ground.addChild(container);

    for(i in 0...50){
      var icon:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(i);
      manualDisposer.push(icon);
      container.addChild(icon);
    }

    manualRemover.push(container);
  }

  override function deactivate(){
    manualDisposer.iter(function(actor:Dynamic){
      actor.deactivate();
      return null;
    });
    manualRemover.iter(function(el:DisplayObjectContainer){
      el.removeChildren();
      return null;
    });
    manualDisposer = manualRemover = null;
    super.deactivate();
  }
}
