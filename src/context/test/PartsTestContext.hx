package context.test;
import model.common.ButtonProp;
import model.common.ActorProp;
import view.common.Checkbox;
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
    layout.gap = 20;
    layout.paddingTop = 20;

    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    ground.addChild(container);

    var button:Button = Button.normal('normal button', null, function(){
      trace('push');
    });

    var fab:ButtonProp = new ButtonProp();
    fab.faChar = Fa.char.paw;
    var faButton:Button = Button.normal('button with icon', fab, function(){
      trace('push');
    });

    var check:Checkbox = Checkbox.normal('checked box', true, ActorHorizontal.Right, function(cb:Checkbox){
      trace(cb.checked);
    });
    var uncheck:Checkbox = Checkbox.normal('unchecked box', false, ActorHorizontal.Left, function(cb:Checkbox){
      trace(cb.checked);
    });

    var fa:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(0);
    var label:Label = new Label('ラベル', 20, Fa.char.apple);

    button.activate(this, container);
    faButton.activate(this, container);
    check.activate(this, container);
    uncheck.activate(this, container);
    fa.activate(this, container);
    label.activate(this, container);
  }
}
