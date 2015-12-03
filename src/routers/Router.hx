package routers;
import views.common.Sp;
import starling.events.Event;
import events.ContextEvent;
import models.RouterProp;
import contexts.BaseContext;

using additions.Creator;
using additions.Support;

typedef RouterOption = {
  @:optional var rootRouter:Router;
  @:optional var rootContext:Class<BaseContext>;
  @:optional var routeData:RouteData;
}

class Router extends Sp {
  private var history:Array<BaseContext>;

  private var rootRouter:Router;
  public var rootContext:BaseContext;

  private var activeContext:BaseContext;
  private var activeClass:Class<BaseContext>;
  private var activeProp:Dynamic;

  public var noActiveContext(get, never):Bool;
  public var isRoot(get, never):Bool;


  static public function asChild(router:Router, context:BaseContext):Router {
    var child:Router = new Router();
    child.rootRouter = router;
    child.rootContext = context;

    return child;
  }

  static public function asRoot(Context:Class<BaseContext>, ?routeData:RouteData):Router{
    var router:Router = new Router();
    router.rootContext = router.push(Context, routeData);

    return router;
  }

  public function new() {
    super();

    initialize();
  }

  private function initialize() {
    history = new Array();
  }

  public function push(Context:Class<BaseContext>, prop:Dynamic = null):BaseContext {
    deactivateActiveContext();

    return activateNewContext(Context, prop);
  }

  public function replace(Context:Class<BaseContext>, prop:Dynamic = null, forceReload:Bool = false):BaseContext {
    if (!forceReload && Context == activeClass && prop == activeProp) {
      return activeContext;
    }
    deactivateActiveContext();

    return activateNewContext(Context, prop);
  }

  public function activateNewContext(Context:Class<BaseContext>, insertProps:Dynamic = null):BaseContext {
    var context:BaseContext = Context.create([new RouterProp(this, rootContext), insertProps]);
    this.activeContext = context;
    this.activeClass = Context;
    this.activeProp = insertProps;

    addChild(context);

    return context;
  }

  private function deactivateActiveContext() {
    if (noActiveContext) { return; }

    removeContextParts();
    activeContext.deactivate();

    this.activeContext = null;
  }

  public function emit(e:Event) {
    dispatchEvent(e);
    noActiveContext ? null : activeContext.dispatchEvent(e);
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
