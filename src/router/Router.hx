package router;
import starling.events.Event;
import event.ContextEvent;
import model.RouterProp;
import context.BaseContext;
import addition.Def;
import starling.text.TextField;
import starling.display.Sprite;

using addition.Creator;

class Router extends Sprite {
  private var history:Array<BaseContext>;
  private var active:BaseContext;
  private var rooter:Router;

  public function new(rooter:Router = null) {
    super();
    this.rooter = rooter;
    initialize();
  }

  public function push(Context:Class<BaseContext>, insertProps:Dynamic = null) {
    var context:BaseContext = Context.create([new RouterProp(this), insertProps]);

    sweepChildren();
    replaceActiveContext(context);
    history.push(context);
    addChild(context.view);
  }

  public function emit(e:Event) {
    this.dispatchEvent(e);
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
