package context.test;
import view.NormalBg;
import db.Palette;
import model.test.BallTestProp;
import model.blockbreaker.FieldOutSide;
import model.blockbreaker.PlayFieldData;
import model.blockbreaker.BallData;
import view.blockbreaker.Ball;
import starling.events.Event;
import config.Def;
import flash.geom.Point;
import model.RouterProp;

using Lambda;
using addition.Support;

class BallTestContext extends BaseContext {
  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;

  public function new(props:RouterProp, insertProps:BallTestProp = null) {
    super(props);
    ground.y = Def.area.y;
    ground.touchable = false;
    field = new PlayFieldData(0, 0, Def.area.w, Def.area.h);
    ground.addChild(new NormalBg());

    write(book);
    startAnimation();

    var w:Int = Def.area.w;
    var h:Int = Def.area.h;

    var limitation:Int = insertProps.be() ? insertProps.limitation : 10;
    var i:Int = 0;
    var fn:Dynamic = null;
    ground.addEventListener(Event.ENTER_FRAME, fn = function(e:Event) {
      for (ii in 0...100) {
        i++;
        var data:BallData = new BallData(random(w), random(h), Palette.random(), 5, i);
        var ball:Ball = Ball.create(data);
        balls.push(data);
        beOnStage(ball);
      }
      if (i >= limitation) {
        ground.removeEventListener(Event.ENTER_FRAME, fn);
      }
    });

    for(i in 0...ground.numChildren){
      ground.getChildAt(i).touchable = false;
    }
  }

  override function deactivate() {
    balls = null;
    super.deactivate();
  }

  private function random(n:Float):Float {
    return Std.int(Math.floor(Math.random() * n));
  }

  private function book(context:BaseContext) {
    balls = balls.filter(function(data:BallData):Bool {
      data.ready();

      var out:FieldOutSide = field.isOutOfBound(data.next);
      while (out != FieldOutSide.InField) {
        switch(out){
          case FieldOutSide.Top:
            data.refrectY(field.top);
          case FieldOutSide.Right:
            data.refrectX(field.right);
          case FieldOutSide.Left:
            data.refrectX(field.left);
          case FieldOutSide.Bottom:
            data.refrectY(field.bottom);
          default:
        }
        out = field.isOutOfBound(data.next);
      }

      data.move();

      return true;
    });
  }

  private function addBall(p:Point) {
    var data:BallData = new BallData(p.x, p.y, 0xff0000, 10, Math.floor(Math.random() * 360));
    var ball:Ball = Ball.create(data);
    balls.push(data);
    beOnStage(ball);
  }
}
