package view;
/*

実際に表示されているブロック。

 */
import starling.display.Quad;

class Block extends Quad{
  private var life:Int;
  private var ball:Int;

  public function new(width:Int, height:Int, color:UInt) {
    super(width, height, color, false);
  }

  public function hit():Bool{

  }

  // アニメーション要素はない
  public function act(){

  }

  // ライフが0以下にはっていないか
  public function isAlive():Bool {
    return life > 0;
  }
}
