package routers;
import views.common.Sp;
import starling.events.Event;
import events.ContextEvent;
import models.RouterProp;
import contexts.BaseContext;
import starling.display.Sprite;

using additions.Creator;
using additions.Support;

class Router extends Sp {
  private var history:Array<BaseContext>;
  private var active:BaseContext;
  private var rooter:Router;
  private var props:RouterProp;
  private var activeClass:Class<BaseContext>;
  private var activeProp:Dynamic;

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


  public function replace(Context:Class<BaseContext>, insertProps:Dynamic = null, forceReload:Bool = false):BaseContext {
    if (!forceReload && Context == activeClass && insertProps == activeProp) {
      return active;
    }
    sweepChildren();
    deactivateActiveContext();

    var context:BaseContext = Context.create([props, insertProps]);
    activateContext(Context, context, insertProps);

    return context;
  }

  private function deactivateActiveContext() {
    if (active == null) {
      return;
    }
    removeEvent(active);
    active.deactivate();

    this.active = null;
  }

  public function activateContext(Context:Class<BaseContext>, context:BaseContext, insertProps:Dynamic = null) {
    this.active = context;
    this.activeClass = Context;
    this.activeProp = insertProps;
    addEvent(context);
    addChild(context.ground);
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
