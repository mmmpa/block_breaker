package view;
/*

実際に表示されているボール。

 */
import context.BaseContext;
import starling.display.DisplayObjectContainer;
import config.Def;
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

  public static function createChild(size:Int, offset:Int, data:BallData):Quad {
    var child:Quad = new Quad(size, size, data.color, false);
    child.pivotX = child.pivotY = offset;
    return child;
  }

  public function new(size:Int, color:Int, ?data:BallData) {
    super(size, size, color, false);
    pivotX = pivotY = Def.ballOffset;

    child1 = Ball.createChild(Def.ballSize1, Def.ballOffset1, data);
    child2 = Ball.createChild(Def.ballSize2, Def.ballOffset2, data);
    child3 = Ball.createChild(Def.ballSize3, Def.ballOffset3, data);
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
    dispose();
    child1.dispose();
    child2.dispose();
    child3.dispose();
    data = null;
  }

  public function act():Bool {
    move();
    return data.isAlive();
  }

  public function move() {
    child3.x = child2.x;
    child3.y = child2.y;
    child2.x = child1.x;
    child2.y = child1.y;
    child1.x = this.x;
    child1.y = this.y;
    this.x = data.x;
    this.y = data.y;
  }
}
