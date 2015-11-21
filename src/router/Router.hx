package router;
import starling.events.Event;
import event.ContextEvent;
import model.RouterProp;
import context.BaseContext;
import starling.display.Sprite;

using addition.Creator;
using addition.NullOr;

class Router extends Sprite {
  private var history:Array<BaseContext>;
  private var active:BaseContext;
  private var rooter:Router;
  private var props:RouterProp;

  public function new(?rooter:Router, ?contextRoot:BaseContext) {
    super();
    this.rooter = rooter;
    this.props = new RouterProp(this, contextRoot);
    initialize();
  }

  public function push(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    var context:BaseContext = Context.create([props, insertProps]);

    sweepChildren();
    replaceActiveContext(context);
    history.push(context);
    addChild(context.ground);

    return context;
  }

  public function pushRoot(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    props.contextRoot = push(Context, insertProps);

    return props.contextRoot;
  }

  public function emit(e:Event) {
    this.dispatchEvent(e);
    active.be() ? active.dispatchEvent(e) : null;
    if (this.rooter != null) {
      this.rooter.emit(e);
    }
  }

  private function replaceActiveContext(context:BaseContext) {
    removeEvent(this.active);
    this.active = context;
    addEvent(context);
  }

  private function addEvent(context:BaseContext) {
    context.addEventListener(ContextEvent.CREATED, onListen);
  }

  private function onListen(e:Event) {
    this.dispatchEvent(e);
  }

  private function removeEvent(context:BaseContext) {
    if (context == null) {
      return;
    }
    context.removeEventListeners();
  }

  private function initialize() {
    history = new Array();
  }

  private function sweepChildren() {
    this.removeChildren();
  }
}
