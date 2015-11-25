package context.test;
import view.NormalBg;
import model.blockbreaker.ShockHitData;
import model.blockbreaker.PlayFieldData;
import view.blockbreaker.Ball;
import model.blockbreaker.FieldOutSide;
import model.blockbreaker.BallData;
import view.blockbreaker.Shock;
import model.blockbreaker.ShockData;
import starling.events.TouchPhase;
import starling.display.Quad;
import config.Def;
 import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;

class ShockTestContext extends BaseContext {
  private var shocks:Array<ShockData> = new Array();
  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;
    field = new PlayFieldData(0, 0, Def.area.w, Def.area.h);
    ground.addChild(new NormalBg());
    ground.addEventListener(TouchEvent.TOUCH, onTouch);

    var data:BallData = new BallData(100, 100, 0xff0000, 10, Math.floor(Math.random() * 360));
    var ball:Ball = Ball.create(data);
    balls.push(data);
    beOnStage(ball);

    write(book);

    startAnimation();
  }

  private function book(context:BaseContext) {
    shocks = shocks.filter(function(data:ShockData):Bool{
      data.spread();
      return !data.isCompleted();
    });
    balls = balls.filter(function(data:BallData):Bool{
      data.ready();

      var loop:Bool = true;
      while(loop){
        loop = false;
        shocks.iter(function(shock:ShockData){
          var hitData:ShockHitData = shock.hit(data.prev, data.next);
          if(hitData != null && data.hittedId != hitData.id){
            data.hittedId = hitData.id;
            data.resetRadian(hitData.radian);
            data.shift(hitData.point.x, hitData.point.y, hitData.next.x, hitData.next.y);
            loop = true;
          }
        });
        var out:FieldOutSide = field.isOutOfBound(data.next);
        while(out != FieldOutSide.InField){
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
          loop = true;
          out = field.isOutOfBound(data.next);
        }
      }

      data.move();

      return true;
    });
  }
  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);
    var position:Point = touch.getLocation(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        shock(position);
    }
  }

  private function shock(p:Point) {
    var data:ShockData = new ShockData(Std.int(p.x), Std.int(p.y), 2);
    var shock:Shock = new Shock(data);
    shocks.push(data);
    beOnStage(shock);
  }
}
