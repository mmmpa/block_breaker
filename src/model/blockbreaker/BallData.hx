package model.blockbreaker;
import flash.geom.Point;
class BallData {
  public var hittedId:Int = 0;

  public var x:Int;
  public var y:Int;
  public var color:Int;

  public var realX:Float;
  public var realY:Float;
  public var moveX:Float;
  public var moveY:Float;

  public var pow:Float;

  private var speed:Float;
  public var radian:Float;

  public var prev:Point = new Point();
  public var next:Point = new Point();

  public var alive:Bool = true;

  public function new(x:Float, y:Float, color:Int, speed:Int, radian:Float) {
    this.x = Std.int(x);
    this.y = Std.int(y);
    this.realX = x;
    this.realY = y;
    this.color = color;
    this.speed = speed;
    this.radian = radian;
    resetMovement();
  }

  public function die() {
    alive = false;
  }

  public function isAlive():Bool {
    return alive;
  }

  public function ready() {
    shift(realX, realY, realX + moveX, realY + moveY);
  }

  public function shift(prevX:Float, prevY:Float, nextX:Float, nextY:Float) {
    prev.setTo(prevX, prevY);
    next.setTo(nextX, nextY);
    move();
  }

  public function move() {
    this.realX = next.x;
    this.realY = next.y;
    this.x = Std.int(realX);
    this.y = Std.int(realY);
  }

  public function resetRadian(radian:Float) {
    this.radian = radian;
    resetMovement();
  }

  public function refrectX(base:Float, ?y:Float) {
    moveX *= -1;

    if (y == null) {
      pow = getPow(prev, next);
      prev.y = prev.y + (base - prev.x) / pow;
    } else {
      prev.y = y;
    }
    next.x = base - (next.x - base);
    prev.x = base + (moveX < 0 ? -1 : 1);

  }

  public function refrectY(base:Float, ?x:Float) {
    moveY *= -1;

    if (x == null) {
      pow = getPow(prev, next);
      prev.x = prev.x + (base - prev.y) * pow;
    } else {
      prev.x = x;
    }
    next.y = base - (next.y - base);
    prev.y = base + (moveY < 0 ? -1 : 1);
  }

  public function resetMovement() {
    this.moveX = Math.cos(radian) * this.speed;
    this.moveY = Math.sin(radian) * this.speed;
    if(Math.isNaN(moveX) || Math.isNaN(moveY)){
      this.moveX = 0;
      this.moveY = 1;
    }
  }

  @:extern inline function getPow(start:Point, end:Point):Float {
    var result:Float = (end.x - start.x) / (end.y - start.y);
    return Math.isNaN(result) ? (end.x - start.x) != 0 ? end.x - start.x : 1 : result;
  }
}
