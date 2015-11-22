package context.test;
import starling.display.DisplayObjectContainer;
import addition.Def;
import feathers.layout.VerticalLayout;
import feathers.layout.HorizontalLayout;
import feathers.controls.ScrollContainer;
import view.common.Label;
import asset.Fa;
import view.common.FaIcon;
import view.common.Button;
import model.RouterProp;

using Lambda;

class FeatherTestContext extends BaseContext {
  private var manualDisposer:Array<Dynamic> = new Array();
  private var manualRemover:Array<DisplayObjectContainer> = new Array();

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();

    var container:ScrollContainer = new ScrollContainer();
    container.width = Def.stage.stageWidth;
    container.height = Def.stage.stageHeight;
    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.padding = 0;
    container.layout = layout;
    ground.addChild(container);


    var button:Button = Button.normal(function() {
      trace('push');
    });

    var faButton:Button = Button.normal(function() {
      trace('push');
    }, null, null, Fa.char.apple);

    var fa:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(0);
    var label:Label = new Label('ラベル', 20, Fa.char.apple);

    button.activate(this, container);
    container.addChild(fa);
    container.addChild(label);

    for(i in 0...50){
      var icon:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(i);
      manualDisposer.push(icon);
      container.addChild(icon);
    }

    manualDisposer.push(button);
    manualDisposer.push(faButton);
    manualDisposer.push(fa);
    manualDisposer.push(label);
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
