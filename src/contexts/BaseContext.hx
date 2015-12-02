package contexts;
import starling.display.Sprite;
import views.common.Sp;
import starling.display.DisplayObjectContainer;
import routers.RouteData;
import configs.Def;
import starling.events.Event;
import events.ContextEvent;
import starling.events.EventDispatcher;
import routers.Router;
import models.RouterProp;

using Lambda;

class BaseContext extends Sprite {
  public var iAmContext:Bool = true;

  private var that:BaseContext;

  private var rooter:BaseContext;
  private var props:RouterProp;
  private var router:Router;
  private var routeMap:Map<String, Dynamic> = new Map();

  private var actors:List<Dynamic> = new List();
  private var books:List<Dynamic> = new List();

  private var subActors:List<BaseContext> = new List();
  private var subBooks:List<BaseContext> = new List();

  public var isRoot(get, never):Bool;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super();
    this.that = this;
    this.props = props;
    this.router = props.router;
    this.rooter = props.contextRoot;

    addEventListener(Event.ADDED_TO_STAGE, _onCreate);
  }

  // 毎フレーム処理関係のメソッド

  public function startAnimation() {
    if (isRoot) {
      Def.stage.addEventListener(Event.ENTER_FRAME, work);
    } else {
      rooter.addSubActors(this);
      rooter.addSubBooks(this);
    }
  }

  public function stopAnimation() {
    if (isRoot) {
      Def.stage.removeEventListener(Event.ENTER_FRAME, work);
    } else {
      rooter.removeSubActors(this);
      rooter.removeSubBooks(this);
    }
  }

  private function work(e:Event) {
    plan();
    action();
  }

  // actorの処理

  public function action() {
    for(actor in actors){
      if(!actor.act()){
        actor.deactivate();
        actors.remove(actor);
      }
    }

    for(sub in subActors){
      sub.action();
    }
  }

  public function addActor(actor:Dynamic, fixed:Bool = false, container:DisplayObjectContainer = null) {
    actor.activate(this, container != null ? container : this);

    if (!fixed) { warmUp(actor); }
  }

  private function warmUp(actor:Dynamic) {
    actors.push(actor);
    actor.act();
  }

  public function removeAllActors() {
    for(actor in actors){
      actor.deactivate();
    }
    actors.clear();
  }

  // bookの処理

  public function plan() {
    for(book in books){
      book(this);
    }
    for(sub in subBooks){
      sub.plan();
    }
  }

  public function addBook(book:Dynamic) {
    books.push(book);
  }

  public function removeBook(book:Dynamic) {
    books.remove(book);
  }

  // サブcontextからの処理

  public function addSubActors(sub:BaseContext) {
    subActors.push(sub);
  }

  public function removeSubActors(sub:BaseContext) {
    subActors.remove(sub);
  }

  public function addSubBooks(sub:BaseContext) {
    subBooks.push(sub);
  }

  public function removeSubBooks(sub:BaseContext) {
    subBooks.remove(sub);
  }

  // routerから呼ばれる

  public function deactivate() {
    stopAnimation();
    removeEventListeners();

    Def.stage.addEventListener(Event.ENTER_FRAME, deactivateStepwise);
  }

  // actorが多い場合、そのdeactivateでフリーズするので回避策として徐々にdeactivateする

  private function deactivateStepwise(e:Event) {
    for (i in 0...Def.deactivationAmoutOnce) {
      if (actors.length == 0) {
        Def.stage.removeEventListener(Event.ENTER_FRAME, deactivateStepwise);
        removeChildren();
        break;
      }
      var actor:Dynamic = actors.pop();
      actor.deactivate();
    }
  }

  public function go(route:RouteData) {
    routeMap.get(route.route)(route);
  }

  public function emit(e:Event) {
    dispatchEvent(e);
    router.emit(e);
  }

  private function _onCreate(e:Event) {
    removeEventListener(Event.ADDED_TO_STAGE, _onCreate);
    emit(new Event(ContextEvent.CREATED));
  }

  public function get_isRoot():Bool {
    return this.rooter == null;
  }

  @:extern inline private function isContext(a:Dynamic):Bool {
    return Reflect.hasField(a, 'iAmContext');
  }
}
