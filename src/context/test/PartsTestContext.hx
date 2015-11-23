package context.test;
import config.Def;
 import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import view.common.Label;
import asset.Fa;
import view.common.FaIcon;
import view.common.Button;
import model.RouterProp;

using Lambda;

class PartsTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;
    startAnimation();

    var layout:VerticalLayout = new VerticalLayout();

    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    ground.addChild(container);

    var button:Button = Button.normal(function(){
      trace('push');
    });

    var faButton:Button = Button.normal(function(){
      trace('push');
    }, null, 'アイコン', Fa.char.apple);

    var fa:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(0);
    var label:Label = new Label('ラベル', 20, Fa.char.apple);

    button.activate(this, container);
    faButton.activate(this, container);
    fa.activate(this, container);
    label.activate(this, container);
  }
}
