package context.test;
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
      container.addChild(icon);
    }
  }
}
