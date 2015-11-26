package context.test;
import view.common.PresetButton;
import feathers.layout.HorizontalLayout;
import view.NormalBg;
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
    ground.addChild(new NormalBg());

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.paddingTop = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;

    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    container.width = Def.area.w;
    container.height = Def.area.h;
    ground.addChild(container);

    var button:Button = PresetButton.normal('normal button', null, function(){
      trace('push');
    });

    var fab:ButtonProp = new ButtonProp();
    fab.faChar = Fa.char.paw;

    var faButton:Button = PresetButton.normal('button with icon', fab, function(){
      trace('push');
    });

    var thum:ButtonProp = new ButtonProp();
    thum.faChar = Fa.char.thumbsOUp;

    var okButton:Button = PresetButton.forOk('ok', thum, function(){
      trace('push');
    });

    var submitButton:Button = PresetButton.forSubmit('submit', thum, function(){
      trace('push');
    });

    var ban:ButtonProp = new ButtonProp();
    ban.faChar = Fa.char.ban;

    var cancelButton:Button = PresetButton.forCansel('cancel', ban, function(){
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
    okButton.activate(this, container);
    submitButton.activate(this, container);
    cancelButton.activate(this, container);
    check.activate(this, container);
    uncheck.activate(this, container);
    fa.activate(this, container);
    label.activate(this, container);
  }
}
