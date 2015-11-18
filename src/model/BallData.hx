package model;
import flash.geom.Point;
class BallData {
  public var x:Int;
  public var y:Int;
  public var color:Int;

  public var realX:Float;
  public var realY:Float;
  public var moveX:Float;
  public var moveY:Float;

  private var speed:Float;
  private var radian:Float;

  public var prev:Point = new Point();
  public var next:Point = new Point();

  public var alive:Bool = true;

  public function new(x:Float, y:Float, color:Int, speed:Int, radian:Int) {
    this.x = Std.int(x);
    this.y = Std.int(y);
    this.realX = x;
    this.realY = y;
    this.speed = speed;
    this.radian = radian - 90;
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
    next.setTo(nextX + moveX, nextY + moveY);
  }

  public function move() {
    this.realX = next.x;
    this.realY = next.y;
    this.x = Std.int(realX);
    this.y = Std.int(realY);
  }

  public function refrectX(base:Float) {
    moveX *= -1;
    next.x = base - (next.x  - base);
    prev.x = base;
  }

  public function refrectY(base:Float) {
    moveY *= -1;
    next.y = base - (next.y  - base);
    prev.y = base;
  }

  public function resetMovement() {
    var base = radian * Math.PI / 180;
    this.moveX = Math.cos(base) * this.speed;
    this.moveY = Math.sin(base) * this.speed;
  }
}