package view.blockbreaker;
/*

実際に表示されているブロック。

 */
import context.BaseContext;
import model.blockbreaker.BlockData;
import config.Def;
 import starling.display.DisplayObjectContainer;
import starling.display.Quad;

class Block extends Quad {
  public var splash:Splash;
  public var data:BlockData;
  private var context:BaseContext;

  public static function create(data:BlockData):Block {
    var block:Block = new Block(data.width - Def.cellMargin, data.height - Def.cellMargin, data.color, data.x, data.y, data);

    return block;
  }

  public function new(width:Int, height:Int, color:Int, x:Int, y:Int, ?data:BlockData) {
    super(width, height, color, false);
    this.x = x;
    this.y = y;
    this.data = data;
    touchable = false;
    initializeSplash();
  }

  private function initializeSplash() {
    var splashX:Int = Std.int(this.x + (this.width / 2));
    var splashY:Int = Std.int(this.y + (this.height / 2));
    this.splash = new Splash(Def.splashFrame, Def.splashSize, this.color, splashX, splashY);
  }

  public function act() {
    return data.isAlive();
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer):Block {
    this.context = context;
    parent.addChild(this);
    return this;
  }

  public function deactivate():Block {
    removeFromParent();
    context.beOnStage(splash);
    return this;
  }

  public function deactivateCalm():Block {
    trace('deactivate');
    removeFromParent();
    dispose();
    splash.deactivate();

    context = null;
    data = null;
    splash = null;

    return this;
  }

}
