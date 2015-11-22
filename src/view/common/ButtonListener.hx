package view.common;
import addition.Def;
import starling.events.TouchEvent;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchPhase;
import starling.display.Quad;

using addition.NullOr;

class ButtonListener extends Quad {
  // for state
  private var prev:Point;
  private var movement:Float;
  private var state:ButtonListenerState = ButtonListenerState.Ready;

  // calllback
  public var down:Dynamic;
  public var click:Dynamic;
  public var drag:Dynamic;
  public var release:Dynamic;
  public var hover:Dynamic;
  public var out:Dynamic;

  // state getter
  public var ready(get, never):Bool;
  public var moved(get, never):Bool;
  public var hovered(get, never):Bool;

  public function new(w:Int, h:Int, alpha:Float = 0) {
    super(w, h, 0, false);
    this.alpha = alpha;
    this.addEventListener(TouchEvent.TOUCH, onTouch);
  }

  public function deactivate() {
    down = click = drag = release = null;
    removeEventListeners();
    dispose();
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(parent);

    if (!touch.be()) {
      if (hovered) { out.be() && out(); }
      state = ButtonListenerState.Ready;
      return;
    }

    var position:Point = touch.getLocation(parent);
    var nowHovered:Bool = hovered;

    switch(touch.phase){
      case TouchPhase.BEGAN:
        state = ButtonListenerState.Began;
        movement = 0;
        down.be() && down();
      case TouchPhase.HOVER:
        if (ready) {
          hover.be() && hover();
          state = ButtonListenerState.Hovered;
        }
      case TouchPhase.MOVED:
        if (!moved) {
          movement += distance(prev, position);
          if (isMovedLong()) {
            state = ButtonListenerState.Moved;
          }
        }
        drag.be() && drag();
      case TouchPhase.ENDED:
        if (!moved) {
          click.be() && click();
        }
        release.be() && release();
        state = ButtonListenerState.Ready;
    }

    if (nowHovered && !hovered) { out.be() && out(); }

    prev = position;
  }

  private function inArea(p:Point):Bool {
    return 0 <= p.x || 0 <= p.y || p.x <= parent.width || p.y <= parent.height;
  }

  private function isMovedLong():Bool {
    return movement > Def.dragDistance;
  }

  private function get_moved():Bool {
    return state == ButtonListenerState.Moved;
  }

  private function get_hovered():Bool {
    return state == ButtonListenerState.Hovered;
  }

  private function get_ready():Bool {
    return state == ButtonListenerState.Ready;
  }

  @:extern inline function distance(a:Point, b:Point):Float {
    var x:Float = b.x - a.x;
    var y:Float = b.y - a.y;
    return Math.sqrt(x * x + y * y);
  }
}

enum ButtonListenerState {
  Ready;
  Began;
  Moved;
  Ended;
  Hovered;
}