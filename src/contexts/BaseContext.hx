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
  public var rooter:BaseContext;
  public var ground:Sp;
  public var props:RouterProp;
  public var router:Router;
  public var routeMap:Map<String, Dynamic> = new Map();
  public var books:Array<Dynamic> = new Array();
  public var actors:Array<Dynamic> = new Array();

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super();

    this.props = props;
    this.router = props.router;
    this.rooter = props.contextRoot;

    ground = new Sp();
    ground.addEventListener(Event.ADDED_TO_STAGE, _onCreate);
  }

  public function isRoot():Bool {
    return this.rooter == null;
  }

  public function startAnimation() {
    if (isRoot()) {
      ground.addEventListener(Event.ENTER_FRAME, _animate);
    } else {
      rooter.addActors(this);
      rooter.addBooks(this);
    }
  }

  public function stopAnimation() {
    if (isRoot()) {
      ground.removeEventListener(Event.ENTER_FRAME, _animate);
    } else {
      rooter.removeActors(this);
      rooter.removeBooks(this);
    }
    trace(rooter);
  }

  public function toString():String {
    return ['actors', Std.string(actors.length), 'books', Std.string(books.length)].join(' ');
  }

  public function write(book:Dynamic) {
    books.push(book);
  }

  public function erase(target:Dynamic) {
    books = books.filter(function(book:Dynamic):Bool {
      return book != target;
    });
  }

  public function addActors(subActors:BaseContext) {
    actors.push(subActors);
  }

  public function removeActors(subActors:BaseContext) {
    actors = actors.filter(function(actor) {
      return actor != subActors;
    });
  }

  public function addBooks(subBooks:BaseContext) {
    books.push(subBooks);
  }

  public function deactivate() {
    stopAnimation();
    ground.removeEventListeners();

    Def.stage.addEventListener(Event.ENTER_FRAME, deactivateSlowly);
  }

  private function deactivateSlowly(e:Event) {
    for (i in 0...Def.deactiveLimit) {
      if (actors.length == 0) {
        Def.stage.removeEventListener(Event.ENTER_FRAME, deactivateSlowly);
        ground.removeChildren();
        break;
      }
      var actor:Dynamic = actors.pop();
      actor.deactivate();
    }
  }

  public function sweep() {
    for (actor in actors) {
      actor.deactivate();
    }
    actors = [];
  }

  public function removeBooks(subBooks:BaseContext) {
    books = books.filter(function(book) {
      return book != subBooks;
    });
  }


  public function beOnStage(actor:Dynamic, calm:Bool = false, container:DisplayObjectContainer = null) {
    if (container == null) {
      actor.activate(this, ground);
    } else {
      actor.activate(this, container);
    }

    if (!calm) {
      actors.push(actor);
      actor.act();
    }
  }

  private function _animate(e:Event) {
    plan();
    action();
  }

  public function plan() {
    for (i in 0...books.length) {
      try {
        var book:Dynamic = books[i];
        if (Reflect.hasField(book, 'plan')) {
          book.plan();
        } else {
          book(this);
        }
      } catch (e:Dynamic) {
        untyped{trace(e.message);}
      }
    }
  }

  public function action() {
    var acted:Array<Dynamic> = new Array();
    var actor:Dynamic;
    while (actor = actors.pop()) {
      if (Reflect.hasField(actor, 'action')) {
        actor.action();
        acted.push(actor);
      } else {
        if (actor.act()) {
          acted.push(actor);
        } else {
          actor.deactivate();
        }
      }
    }

    actors = acted;
  }

  public function go(route:RouteData) {
    routeMap.get(route.route)(route);
  }

  public function emit(e:Event) {
    this.dispatchEvent(e);
    this.router.emit(e);
  }

  private function _onCreate(e:Event) {
    this.ground.removeEventListener(Event.ADDED_TO_STAGE, _onCreate);
    this.emit(new Event(ContextEvent.CREATED));
  }
}

