package model.common;
class BitmapMapColor {
  public var color:Int;
  public var life:Int;
  public var ball:Int;
  public function new(color:Int, life:Int = 1, ball:Int = 0) {
    this.color = color;
    this.life = life;
    this.ball = ball;
  }
}
