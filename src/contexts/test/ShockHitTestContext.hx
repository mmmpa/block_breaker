package contexts.test;
import views.NormalBg;
import views.blockbreaker.Shock;
import models.blockbreaker.ShockData;
import models.blockbreaker.ShockHitData;
import models.blockbreaker.BallData;
import starling.display.DisplayObject;
import flash.geom.Point;
import starling.display.Quad;
import starling.events.TouchPhase;
import configs.Def;
 import starling.events.TouchEvent;
import starling.events.Touch;
import models.RouterProp;
import contexts.BaseContext;

class ShockHitTestContext extends BaseContext {
  private var lineState:String;


  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;

    startAnimation();
    ground.addChild(new NormalBg());

    lineState = 'ready';

    var shock:ShockData = new ShockData(Def.area.w >> 1, Def.area.h >> 1, 50);
    var shockView:Shock = new Shock(shock);

    ground.addChild(shockView);

    var drawStore:Array<Dynamic> = new Array();
    var start:Point = null;
    var end:Point = null;
    var hitData:ShockHitData;


    ground.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
      var touch:Touch = e.getTouch(ground);
      var position:Point = touch.getLocation(ground);
      switch(touch.phase){
        case TouchPhase.BEGAN:
          switch(lineState){
            case 'ready':
              start = position;
              var p:Quad = new Quad(4, 4, 0x00ff00);
              ground.addChild(p);
              drawStore.push(p);
              p.x = position.x - 2;
              p.y = position.y - 2;
              trace('draw start point');
              lineState = 'started';
            case 'started':
              end = position;
              var p:Quad = new Quad(4, 4, 0x0000ff);
              ground.addChild(p);
              drawStore.push(p);
              p.x = position.x - 2;
              p.y = position.y - 2;
              //
              var line = drawLine(start, end);
              ground.addChild(line);
              drawStore.push(line);

              hitData = shock.hit(start, end);
              if (hitData != null) {
                var data:BallData = new BallData(0, 0, 0, 10, 0);
                data.resetRadian(hitData.radian);
                data.shift(hitData.point.x, hitData.point.y, hitData.next.x, hitData.next.y);

                trace([ShockData.hitData.point, ShockData.hitData.next]);

                var hit:Quad = new Quad(4, 4, 0);
                hit.x = data.prev.x - 2;
                hit.y = data.prev.y - 2;
                ground.addChild(hit);
                drawStore.push(hit);

                //data.ready();

                var refrect:Quad = new Quad(4, 4, 0);
                refrect.x = data.next.x - 2;
                refrect.y = data.next.y - 2;
                ground.addChild(refrect);
                drawStore.push(refrect);
                trace('ref p');

                var refline = drawLine(data.prev, data.next);
                ground.addChild(refline);
                drawStore.push(refline);

                data.ready();
                var nextM:Quad = new Quad(4, 4, 0);
                nextM.x = data.next.x - 2;
                nextM.y = data.next.y - 2;
                ground.addChild(nextM);
                drawStore.push(nextM);
              }

              trace('draw end point and line');
              lineState = 'drawn';
            case 'drawn':
              trace('delete');
              drawStore.map(function(el:DisplayObject) {
                el.removeFromParent();
              });
              lineState = 'ready';
          }
      }
    });
  }

  public function drawLine(start:Point, end:Point):Quad {
    var x:Float = end.x - start.x;
    var y:Float = end.y - start.y;
    var distance:Float = Math.sqrt(x * x + y * y);

    if(distance == 0){
      return new Quad(1, 1, 0);
    }

    var radian:Float = Math.atan2(y, x);

    var q:Quad = new Quad(distance, 1, 0);
    q.rotation = radian;
    q.x = start.x;
    q.y = start.y;

    return q;
  }
}
