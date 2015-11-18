package view;
/*

実際に表示されているボール。

 */
import context.BaseContext;
import starling.display.DisplayObjectContainer;
import addition.Def;
import model.BallData;
import starling.display.Quad;

class Ball extends Quad {
  private var speed:Float;
  private var angle:Float;
  private var data:BallData;

  public static function create(data:BallData):Ball {
    return new Ball(Def.ballSize, data.color, data);
  }

  public function new(size:Int, color:Int, ?data:BallData) {
    super(size, size, color, false);
    this.data = data;
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
  }

  public function deactivate() {
    removeFromParent();
  }

  public function act():Bool {
    move();
    return data.isAlive();
  }

  public function move() {
    this.x = data.x;
    this.y = data.y;
  }

  // ステージの外に出ていないか

  public function isAlive():Bool {
    return true;
  }
}
