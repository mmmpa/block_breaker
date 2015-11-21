package context.test;
import view.common.Label;
import asset.Fa;
import view.common.FaIcon;
import view.common.Button;
import model.RouterProp;

using Lambda;

class PartsTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    startAnimation();

    var button:Button = Button.normal(function(){
      trace('push');
    });

    var faButton:Button = Button.normal(function(){
      trace('push');
    }, null, null, Fa.char.apple);

    var fa:FaIcon = new FaIcon(Fa.char.apple, 56).scale(2).rotate(0);
    var label:Label = new Label('ラベル', 20, Fa.char.apple);

    button.x = button.y = 100;
    beOnStage(button, true);
    beOnStage(fa, true);
    beOnStage(label, true);
  }
}
