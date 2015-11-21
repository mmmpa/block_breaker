package view.common;
import addition.Def;
import starling.events.TouchEvent;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchPhase;
import starling.display.Quad;

using addition.NullOr;

class ButtonListener extends Quad {
  public var down:Dynamic;
  public var click:Dynamic;
  public var drag:Dynamic;
  public var release:Dynamic;
  public var hover:Dynamic;
  public var out:Dynamic;

  public var rollOutListener:Dynamic;

  public var prev:Point;
  public var movement:Float;
  public var state:ButtonListenerState = ButtonListenerState.Ready;

  // state
  public var ready(get, never):Bool;
  public var moved(get, never):Bool;
  public var hovered(get, never):Bool;

  public function new(w:Int, h:Int) {
    super(w, h, 0, false);
    this.alpha = 0;
    this.addEventListener(TouchEvent.TOUCH, onTouch);
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(parent);
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
          var listener:ButtonListener = this;
          stage.addEventListener(TouchEvent.TOUCH, rollOutListener = function(e:TouchEvent) {
            if (e.target != listener) {
              stage.removeEventListener(TouchEvent.TOUCH, rollOutListener);
              if (hovered) {
                state = ButtonListenerState.Ready;
                out.be() && out();
              }
            };
          });
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
    if (nowHovered && !hovered) {
      rollOutListener.be() ? stage.removeEventListener(TouchEvent.TOUCH, rollOutListener) : null;
      out.be() && out();
    }
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

  public function deactivate() {
    down = click = drag = release = null;
    removeEventListeners();
    dispose();
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