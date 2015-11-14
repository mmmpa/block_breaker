package context;
import starling.events.Event;
import starling.text.TextField;
import model.RouterProp;
import event.ContextEvent;

class BodyContext extends BaseContext {
  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);

    initialize();

    var tf:TextField = new TextField(100, 50, 'body context2');
    tf.x = 100;
    this.view.addChild(tf);

    this.addEventListener(ContextEvent.CREATED, function(e:Event){
      trace('body', e.target);
    });

    if (insertProps != null) {
      go(insertProps.route, insertProps);
    }
  }

  private function initialize() {
    initializeRouteMap();
  }

  private function initializeRouteMap() {
    routeMap.set('/', function(insertProps) {
      trace('body /');
    });
  }
}
