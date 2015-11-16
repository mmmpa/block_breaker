package addition;
import flash.geom.Point;

class Cell {
  static public function isSameCell(start:Point, end:Point):Bool {
    return start.x == end.x && start.y == end.y;
  }

  static public function isSameY(start:Point, end:Point):Bool {
    return start.y == end.y;
  }

  static public function isSameX(start:Point, end:Point):Bool {
    return start.x == end.x;
  }

  static public function movementX(start:Point, end:Point):Int {
    return Std.int(abs(end.x - start.x));
  }

  static public function movementY(start:Point, end:Point):Int {
    return Std.int(abs(end.y - start.y));
  }

  static public function abs(a:Float):Float {
    return a < 0 ? a * -1 : a;
  }
}
