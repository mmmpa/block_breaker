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
}
