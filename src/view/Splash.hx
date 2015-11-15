package view;
/*
ブロックが破壊された時のアニメーション
 */
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
class Splash {
  private var s1:Quad;
  private var s2:Quad;
  private var s3:Quad;
  private var s4:Quad;

  private var frame:Int;

  public function new(frame:Int, size:UInt, color:UInt, x:Int, y:Int) {
    this.frame = frame;
    s1 = create(size, color, x, y);
    s2 = create(size, color, x, y);
    s3 = create(size, color, x, y);
    s4 = create(size, color, x, y);
  }

  public function act():Bool {
    frame--;

    var range:Int = Std.int(frame / 2);

    s1.x -= range;
    s1.y -= range;

    s2.x += range;
    s2.y -= range;

    s3.x -= range;
    s3.y += range;

    s4.x += range;
    s4.y += range;

    s1.width = s1.height =
    s2.width = s2.height =
    s3.width = s3.height =
    s4.width = s4.height *= 0.8;

    return isAlive();
  }

  public function isAlive():Bool {
    if (frame < 0) {
      return false;
    } else {
      return true;
    }
  }

  public function activate(parent:DisplayObjectContainer):Splash {
    parent.addChild(s1);
    parent.addChild(s2);
    parent.addChild(s3);
    parent.addChild(s4);

    return this;
  }

  public function deactivate():Splash {
    s1.removeFromParent();
    s2.removeFromParent();
    s3.removeFromParent();
    s4.removeFromParent();

    return this;
  }

  private function create(size:UInt, color:UInt, x:Int, y:Int):Quad {
    var q:Quad = new Quad(size, size, color);
    var offset:Int = size >> 1;
    q.x = x;
    q.y = y;
    q.pivotX = q.pivotY = offset;

    return q;
  }
}
