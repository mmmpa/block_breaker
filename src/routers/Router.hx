package routers;
import views.common.Sp;
import starling.events.Event;
import events.ContextEvent;
import models.RouterProp;
import contexts.BaseContext;

using additions.Creator;
using additions.Support;

class Router extends Sp {
  private var history:Array<BaseContext>;

  private var rootRouter:Router;
  private var rootContext:BaseContext;
  private var props:RouterProp;

  private var activeContext:BaseContext;
  private var activeClass:Class<BaseContext>;
  private var activeProp:Dynamic;

  public var noActiveContext(get, never):Bool;
  public var isRoot(get, never):Bool;


  public function new(?rootRouter:Router, ?rootContext:BaseContext) {
    super();
    this.rootRouter = rootRouter;
    this.rootContext = rootContext;
    this.props = new RouterProp(this, rootContext);

    initialize();
  }

  private function initialize() {
    history = new Array();
  }

  public function push(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    deactivateActiveContext();

    return activateNewContext(Context, insertProps);
  }

  public function replace(Context:Class<BaseContext>, insertProps:Dynamic = null, forceReload:Bool = false):BaseContext {
    if (!forceReload && Context == activeClass && insertProps == activeProp) {
      return activeContext;
    }
    deactivateActiveContext();

    return activateNewContext(Context, insertProps);
  }

  public function activateNewContext(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    var context:BaseContext = Context.create([props, insertProps]);
    this.activeContext = context;
    this.activeClass = Context;
    this.activeProp = insertProps;

    addEvent(context);
    addChild(context.ground);

    return context;
  }

  private function deactivateActiveContext() {
    if (noActiveContext) { return; }

    removeContextParts();
    activeContext.deactivate();

    this.activeContext = null;
  }

  public function pushRoot(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    props.contextRoot = push(Context, insertProps);

    return props.contextRoot;
  }

  public function emit(e:Event) {
    dispatchEvent(e);
    noActiveContext ? null : activeContext.dispatchEvent(e);
    isRoot ? null : this.rootRouter.emit(e);
  }

  private function addEvent(context:BaseContext) {
    context.addEventListener(ContextEvent.CREATED, onListen);
  }

  private function onListen(e:Event) {
    dispatchEvent(e);
    isRoot ? null : this.rootRouter.emit(e);
  }

  private function removeContextParts() {
    removeChildren();
  }

  public function get_isRoot():Bool {
    return rootRouter == null;
  }

  public function get_noActiveContext():Bool {
    return activeContext == null;
  }
}
