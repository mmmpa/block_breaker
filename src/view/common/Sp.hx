package view.common;
import starling.display.DisplayObject;
import flash.geom.Point;
import starling.display.Sprite;
class Sp extends Sprite {
  public function new() {
    super();
  }

  override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject {
    // for debug
    //trace([this.name, forTouch]);
    return super.hitTest(localPoint, forTouch);
  }
}
