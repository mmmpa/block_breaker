package view;
/*

実際に表示されているボール。

 */
import starling.display.Quad;

class Ball extends Quad {
  private var speed:Float;
  private var angle:Float;

  public function new(width:Int, height:Int, color:Int) {
    super(width, height, color, false);
  }

  public function act() {
    move();
  }

  public function move() {

  }

  // ステージの外に出ていないか
  public function isAlive():Bool {
    return true;
  }
}
