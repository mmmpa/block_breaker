package contexts;
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

class BaseContext extends EventDispatcher {
  public var iAmContext:Bool = true;

  public var ground:Sp;

  private var rooter:BaseContext;
  private var props:RouterProp;
  private var router:Router;
  private var routeMap:Map<String, Dynamic> = new Map();

  private var actors:Array<Dynamic> = new Array();
  private var books:Array<Dynamic> = new Array();

  public var isRoot(get, never):Bool;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super();

    this.props = props;
    this.router = props.router;
    this.rooter = props.contextRoot;

    ground = new Sp();
    ground.addEventListener(Event.ADDED_TO_STAGE, _onCreate);
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
    var acted:Array<Dynamic> = new Array();
    for (actor in actors) {
      if (isContext(actor)) {
        actor.action();
        acted.push(actor);
      } else {
        actor.act() ? acted.push(actor) : actor.deactivate();
      }
    }

    actors = acted;
  }

  public function addActor(actor:Dynamic, fixed:Bool = false, container:DisplayObjectContainer = null) {
    actor.activate(this, container != null ? container : ground);

    if (!fixed) { warmUp(actor); }
  }

  private function warmUp(actor:Dynamic) {
    actors.push(actor);
    actor.act();
  }

  public function removeAllActors() {
    for (actor in actors) { actor.deactivate(); }
    actors = [];
  }

  // bookの処理

  public function plan() {
    for (book in books) {
      try {
        isContext(book) ? cast(book, BaseContext).plan() : book(this);
      } catch (e:Dynamic) {
        untyped{ trace(e.message); }
      }
    }
  }

  public function addBook(book:Dynamic) {
    books.push(book);
  }

  public function removeBook(target:Dynamic) {
    books = books.filter(function(book:Dynamic):Bool {
      return book != target;
    });
  }

  // サブcontextからの処理

  public function addSubActors(subActors:BaseContext) {
    actors.push(subActors);
  }

  public function removeSubActors(subActors:BaseContext) {
    actors = actors.filter(function(actor) {
      return actor != subActors;
    });
  }

  public function addSubBooks(subBooks:BaseContext) {
    books.push(subBooks);
  }

  public function removeSubBooks(subBooks:BaseContext) {
    books = books.filter(function(book) {
      return book != subBooks;
    });
  }

  // routerから呼ばれる

  public function deactivate() {
    stopAnimation();
    ground.removeEventListeners();

    Def.stage.addEventListener(Event.ENTER_FRAME, deactivateStepwise);
  }

  // actorが多い場合、そのdeactivateでフリーズするので回避策として徐々にdeactivateする

  private function deactivateStepwise(e:Event) {
    for (i in 0...Def.deactivationAmoutOnce) {
      if (actors.length == 0) {
        Def.stage.removeEventListener(Event.ENTER_FRAME, deactivateStepwise);
        ground.removeChildren();
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
    ground.removeEventListener(Event.ADDED_TO_STAGE, _onCreate);
    emit(new Event(ContextEvent.CREATED));
  }

  public function get_isRoot():Bool {
    return this.rooter == null;
  }

  @:extern inline private function isContext(a:Dynamic):Bool {
    return Reflect.hasField(a, 'amContext');
  }
}
