package context.test;
import model.FieldOutSide;
import model.PlayFieldData;
import model.BallData;
import view.Ball;
import model.BallData;
import view.Splash;
import starling.events.Event;
import starling.events.TouchPhase;
import starling.display.Quad;
import addition.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;

class BallTestContext extends BaseContext {

  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    field = new PlayFieldData(0, 0, Def.stage.stageWidth, Def.stage.stageHeight);
    view.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xcccccc));
    view.addEventListener(TouchEvent.TOUCH, onTouch);

    write(book);
    startAnimation();

    var i:Int = 0;
    var fn:Dynamic = null;
    view.addEventListener(Event.ENTER_FRAME, fn = function(e:Event){
      i++;
      var data:BallData = new BallData(100, 100, 0xff0000, 1, i);
      var ball:Ball = Ball.create(data);
      balls.push(data);
      beOnStage(ball);
      if(i % 360 == 0){
        view.removeEventListener(Event.ENTER_FRAME, fn);
      }
    });
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(Def.stage);
    var position:Point = touch.getLocation(Def.stage);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        addBall(position);
    }
  }

  private function book(context:BaseContext) {
    balls = balls.filter(function(data:BallData):Bool{
      data.ready();

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
