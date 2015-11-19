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
    ground = new Sprite();
    ground.addEventListener(Event.ADDED_TO_STAGE, _onCreate);
  }

  public function startAnimation() {
    ground.addEventListener(Event.ENTER_FRAME, _animate);
  }

  public function stopAnimation() {
    ground.removeEventListener(Event.ENTER_FRAME, _animate);
  }

  public function write(book:Dynamic) {
    books.push(book);
  }

  public function erase(target:Dynamic){
    books.filter(function(book:Dynamic):Bool{
      return book != target;
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
    for (i in 0...books.length) {
      try {
        books[i](this);
      } catch (e:Dynamic) {}
    }

    var acted:Array<Dynamic> = new Array();
    var actor:Dynamic;
    while (actor = actors.pop()) {
      if (actor.act()) {
        acted.push(actor);
      } else {
        actor.deactivate();
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


