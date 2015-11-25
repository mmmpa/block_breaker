package model.blockbreaker;
import flash.geom.Point;
class BlockData {
  public var color:Int;
  public var life:Int;
  public var ball:Int;

  public var col:Int;
  public var row:Int;

  public var x:Int;
  public var y:Int;
  public var width:Int;
  public var height:Int;

  public var top:Float;
  public var right:Float;
  public var bottom:Float;
  public var left:Float;

  public var ballP:Point;

  public function new(color:Int, life:Int, ball:Int) {
    this.color = color;
    this.life = life;
    this.ball = ball;
  }

  public function realize(col:Int, row:Int, width:Int, height:Int) {
    this.col = col;
    this.row = row;
    this.width = width;
    this.height = height;

    posit();
  }

  public function isAlive():Bool {
    return life > 0;
  }

  public function hasBall():Bool {
    return ball > 0;
  }

  public function hit(damage:Int = 1) {
    life -= damage;
  }

  private function posit() {
    this.x = width * col;
    this.y = height * row;
    this.top = y;
    this.right = x + width;
    this.bottom = y + height;
    this.left = x;

    this.ballP = new Point(x + (width >> 1), y + (height >> 1));
  }

  public function toString():String {
    return [x, y].join(':');
  }
}
