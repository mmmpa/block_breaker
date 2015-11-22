package context;
import starling.events.Event;
import event.ContextEvent;
import haxe.macro.Context;
import starling.display.Sprite;
import starling.events.EventDispatcher;
import router.Router;
import model.RouterProp;

using Lambda;

class BaseContext extends EventDispatcher {
  public var rooter:BaseContext;
  public var ground:Sprite;
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

    ground = new Sprite();
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
    }
  }

  public function stopAnimation() {
    if (isRoot()) {
      ground.removeEventListener(Event.ENTER_FRAME, _animate);
    } else {
      rooter.removeActors(this);
    }
  }

  public function write(book:Dynamic) {
    books.push(book);

    if (!isRoot()) {
      rooter.addBooks(this);
    }
  }

  public function erase(target:Dynamic) {
    books.filter(function(book:Dynamic):Bool {
      return book != target;
    });

    if (!isRoot()) {
      rooter.removeBooks(this);
    }
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

  public function removeBooks(subBooks:BaseContext) {
    books = books.filter(function(book) {
      return book != subBooks;
    });
  }


  public function beOnStage(actor:Dynamic, calm:Bool = false) {
    actor.activate(this, ground);

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
        trace(e);
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

  public function go(route:String, insertProps:Dynamic = null) {
    routeMap.get(route)(insertProps);
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


