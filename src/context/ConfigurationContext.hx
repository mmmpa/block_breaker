package context;
import starling.events.Event;
import starling.text.TextField;
import model.RouterProp;
import event.ContextEvent;

class ConfigurationContext extends BaseContext {
  public function new(props:RouterProp) {
    super(props);

    var tf:TextField = new TextField(100, 50, 'body context2');
    tf.x = 100;
    this.ground.addChild(tf);

    this.addEventListener(ContextEvent.CREATED, function(e:Event){
      trace('inner', e.target);
    });
  }
}
