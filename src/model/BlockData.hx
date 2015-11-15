package model;
class BlockData {
  public var color:UInt;
  public var life:UInt;
  public var ball:UInt;

  public function new(color:UInt, life:UInt, ball:UInt) {
    this.color = color;
    this.life = life;
    this.ball = ball;
  }
}
