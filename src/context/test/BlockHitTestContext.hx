package context.test;
import starling.display.DisplayObject;
import flash.geom.Point;
import starling.display.Quad;
import starling.events.TouchPhase;
import addition.Def;
import starling.events.TouchEvent;
import starling.events.Touch;
import starling.events.Event;
import view.Block;
import model.BlockGrid;
import model.BlockData;
import model.RouterProp;
import context.BaseContext;

class BlockHitTestContext extends BaseContext {
  private var lineState:String;


  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);

    startAnimation();
    view.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xffeeff));

    lineState = 'ready';

    var datas:Array<BlockData> = new Array();
    for (i in 0...36) {
      datas.push(new BlockData(0xff0000 + i * 10, 1, 1));
    }

    var grid:BlockGrid = new BlockGrid(12, 40, 20, datas);
    beOnStage(grid, true);


    var drawStore:Array<Dynamic> = new Array();
    var start:Point = null;
    var end:Point = null;

    view.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
      var touch:Touch = e.getTouch(Def.stage);
      var position:Point = touch.getLocation(Def.stage);

      switch(touch.phase){
        case TouchPhase.BEGAN:
          switch(lineState){
            case 'ready':
              start = position;
              var p:Quad = new Quad(4, 4, 0x00ff00);
              view.addChild(p);
              drawStore.push(p);
              p.x = position.x - 2;
              p.y = position.y - 2;
              trace('draw start point');
              lineState = 'started';
            case 'started':
              end = position;
              var p:Quad = new Quad(4, 4, 0x0000ff);
              view.addChild(p);
              drawStore.push(p);
              p.x = position.x - 2;
              p.y = position.y - 2;
//
              var line = drawLine(start, end);
              view.addChild(line);
              drawStore.push(line);
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

    var radian:Float = Math.atan2(y, x);

    var q:Quad = new Quad(distance, 1, 0);
    q.rotation = radian;
    q.x = start.x;
    q.y = start.y;

    return q;
  }
}