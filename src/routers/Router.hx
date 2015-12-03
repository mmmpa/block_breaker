package routers;
import views.common.Sp;
import starling.events.Event;
import models.RouterProp;
import contexts.BaseContext;

using additions.Creator;
using additions.Support;

typedef RouterOption = {
  @:optional var rootRouter:Router;
  @:optional var rootContext:Class<BaseContext>;
  @:optional var routeData:SceneChangeData;
}

class Router extends Sp {
  private var history:Array<BaseContext>;

  private var parentRouter:Router;
  public var rootContext:BaseContext;

  private var activeContext:BaseContext;
  private var activeClass:Class<BaseContext>;
  private var activeProp:Dynamic;

  public var noActiveContext(get, never):Bool;
  public var isRoot(get, never):Bool;


  static public function asChild(router:Router, context:BaseContext):Router {
    var child:Router = new Router();
    child.parentRouter = router;
    child.rootContext = context;

    return child;
  }

  static public function asRoot(Context:Class<BaseContext>, ?routeData:SceneChangeData):Router{
    var router:Router = new Router();
    router.rootContext = router.push(Context, routeData, false);
    router.rootContext.finishActivation();
    return router;
  }

  public function new() {
    super();

    initialize();
  }

  private function initialize() {
    history = new Array();
  }

  public function push(Context:Class<BaseContext>, prop:Dynamic = null, autoFinish:Bool = true):BaseContext {
    deactivateActiveContext();

    return activateNewContext(Context, prop, autoFinish);
  }

  public function replace(Context:Class<BaseContext>, prop:Dynamic = null, forceReload:Bool = false):BaseContext {
    if (!forceReload && Context == activeClass && prop == activeProp) {
      return activeContext;
    }
    deactivateActiveContext();

    return activateNewContext(Context, prop);
  }

  public function activateNewContext(Context:Class<BaseContext>, insertProps:Dynamic = null, autoFinish:Bool = true):BaseContext {
    var context:BaseContext = Context.create([new RouterProp(this, rootContext), insertProps]);
    this.activeContext = context;
    this.activeClass = Context;
    this.activeProp = insertProps;

    addChild(context);
    if(autoFinish){
      context.finishActivation();
    }
    return context;
  }

  private function deactivateActiveContext() {
    if (noActiveContext) { return; }

    removeContextParts();
    activeContext.deactivate();

    this.activeContext = null;
  }

  public function emit(e:Event) {
    noActiveContext ? null : activeContext.dispatchEvent(e);
    dispatchEvent(e);
    isRoot ? null : parentRouter.emit(e);
  }

  private function removeContextParts() {
    removeChildren();
  }

  public function get_isRoot():Bool {
    return parentRouter == null;
  }

  public function get_noActiveContext():Bool {
    return activeContext == null;
  }
}
