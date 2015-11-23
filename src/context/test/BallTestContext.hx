package context.test;
import asset.BlockFont;
import db.Palette;
import model.test.BallTestProp;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import model.FieldOutSide;
import model.PlayFieldData;
import model.BallData;
import view.Ball;
import model.BallData;
import view.Splash;
import starling.events.Event;
import starling.events.TouchPhase;
import starling.display.Quad;
import config.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;
using addition.NullOr;

class BallTestContext extends BaseContext {
  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;

  public function new(props:RouterProp, insertProps:BallTestProp = null) {
    super(props);
    ground.y = Def.area.y;

    field = new PlayFieldData(0, 0, Def.area.w, Def.area.h);
    ground.addChild(new Quad(Def.area.w, Def.fullArea.h, Def.testBg));
    ground.addEventListener(TouchEvent.TOUCH, onTouch);

    write(book);
    startAnimation();

    var w:Int = Def.area.w;
    var h:Int = Def.area.h;

    trace(insertProps);
    var limitation:Int = insertProps.be() ? insertProps.limitation : 10;
    var i:Int = 0;
    var fn:Dynamic = null;
    var tf:TextField = new TextField(w, 50, '');
    tf.y = (h + 50) >> 1;
    tf.fontName = BlockFont.name;
    tf.fontSize = 40;
    ground.addChild(tf);
    ground.addEventListener(Event.ENTER_FRAME, fn = function(e:Event) {
      for (ii in 0...100) {
        i++;
        var data:BallData = new BallData(random(w), random(h), Palette.random(), 5, i);
        var ball:Ball = Ball.create(data);
        balls.push(data);
        beOnStage(ball);
      }
      tf.text = Std.string(i);
      if (i >= limitation) {
        ground.removeEventListener(Event.ENTER_FRAME, fn);
      }
    });
  }

  private function random(n:Float):Float {
    return Std.int(Math.floor(Math.random() * n));
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);
    var position:Point = touch.getLocation(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        addBall(position);
    }
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
