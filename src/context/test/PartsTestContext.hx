package context.test;
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

    button.x = button.y = 100;
    beOnStage(button, true);
  }
}
