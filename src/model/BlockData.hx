package model;
class BlockData {
  public var color:UInt;
  public var life:UInt;
  public var ball:UInt;

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

  public function new(color:UInt, life:UInt, ball:UInt) {
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

  private function posit() {
    this.x = width * col;
    this.y = height * row;
    this.top = y;
    this.right = x + width;
    this.bottom = y + height;
    this.left = x;
  }
}
