package views.blockbreaker;
import starling.display.DisplayObject;
import flash.geom.Point;
import starling.display.Sprite;
class Calm extends Sprite{
  public function new() {
    super();
  }

  override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject {
    return null;
  }
}
