package view;
/*

実際に表示されているブロック。

 */
import addition.Def;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;

class Block extends Quad {
  private var life:Int;
  private var ball:Int;
  public var splash:Splash;

  public function new(width:Int, height:Int, color:UInt, life:UInt, ball:UInt, x:Int, y:Int) {
    super(width, height, color, false);
    this.life = life;
    this.ball = ball;
    initializeSplash();
  }

  private function initializeSplash(){
    var splashX:Int = Std.int(this.x + (this.width / 2));
    var splashY:Int = Std.int(this.y + (this.height / 2));
    splash = new Splash(Def.splashFrame, Def.splashSize, this.color, splashX, splashY);
  }

  public function hit():Bool {
    life--;

    return isAlive();
  }

  public function activate(parent:DisplayObjectContainer):Block {
    parent.addChild(this);

    return this;
  }

  public function deactivate():Block {
    removeFromParent();

    return this;
  }

  public function isAlive():Bool {
    return this.life > 0;
  }
}
