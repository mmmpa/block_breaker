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

  private var child1:Quad;
  private var child2:Quad;
  private var child3:Quad;

  public static function create(data:BallData):Ball {
    return new Ball(Def.ballSize, data.color, data);
  }

  public static function createChild(size:Int, data:BallData):Quad {
    return new Quad(size, size, data.color, false);
  }

  public function new(size:Int, color:Int, ?data:BallData) {
    super(size, size, color, false);

    child1 = Ball.createChild(Def.ballSize1, data);
    child2 = Ball.createChild(Def.ballSize2, data);
    child3 = Ball.createChild(Def.ballSize3, data);
    this.data = data;
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
    parent.addChild(child1);
    parent.addChild(child2);
    parent.addChild(child3);
  }

  public function deactivate() {
    removeFromParent();
    child1.removeFromParent();
    child2.removeFromParent();
    child3.removeFromParent();
  }

  public function act():Bool {
    move();
    return data.isAlive();
  }

  public function move() {
    child3.x = child2.x + Def.ballOffset3;
    child3.y = child2.y + Def.ballOffset3;
    child2.x = child1.x + Def.ballOffset2;
    child2.y = child1.y + Def.ballOffset2;
    child1.x = this.x + Def.ballOffset1;
    child1.y = this.y + Def.ballOffset1;
    this.x = data.x - Def.ballOffset;
    this.y = data.y - Def.ballOffset;
  }

  // ステージの外に出ていないか

  public function isAlive():Bool {
    return true;
  }
}
