package addition;
import starling.display.DisplayObject;
class Positter {
  static public function posit(object:DisplayObject, x:Int = null, y:Int = null) {
    if (x != null) {
      object.x = x;
    }
    if (y != null) {
      object.y = y;
    }
  }
}
