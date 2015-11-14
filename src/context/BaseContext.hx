package context;
import starling.events.Event;
import event.ContextEvent;
import haxe.macro.Context;
import starling.display.Sprite;
import starling.events.EventDispatcher;
import router.Router;
import model.RouterProp;
import starling.display.DisplayObjectContainer;

class BaseContext extends EventDispatcher {
  public var view:DisplayObjectContainer;
  public var props:RouterProp;
  public var router:Router;
  public var routeMap:Map<String, Dynamic> = new Map();


  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super();

    this.props = props;
    this.router = props.router;
    this.view = new Sprite();

    this.view.addEventListener(Event.ADDED_TO_STAGE, _onCreate);
  }

  public function go(route:String, insertProps:Dynamic = null) {
    routeMap.get(route)(insertProps);
  }

  public function emit(e:Event) {
    this.dispatchEvent(e);
    this.router.emit(e);
  }

  private function _onCreate(e:Event){
    this.view.removeEventListener(Event.ADDED_TO_STAGE, _onCreate);
    this.emit(new Event(ContextEvent.CREATED));
  }
}


