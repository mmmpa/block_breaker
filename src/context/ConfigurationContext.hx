package context;
import config.Configuration;
import view.common.Button;
import config.Def;
 import model.ConfigurationProp;
import starling.events.Event;
import starling.text.TextField;
import model.RouterProp;
import event.ContextEvent;

class ConfigurationContext extends BaseContext {
  public function new(props:RouterProp, insertProps:ConfigurationProp = null) {
    super(props);
    ground.y = Def.area.y;

    startAnimation();

    var button:Button = Button.normal(function(){
      trace(!Configuration.statusEnabled);
      Configuration.statusEnabled = !Configuration.statusEnabled;
      Configuration.save();
    });

    beOnStage(button);
  }
}
