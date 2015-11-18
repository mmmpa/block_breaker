package context.test;
import model.BlockHitSide;
import model.FieldOutSide;
import model.BallData;
import model.BallData;
import model.BlockHitData;
import view.BlockTable;
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
    view.name = 'block hit context';

    lineState = 'ready';

    var datas:Array<BlockData> = new Array();
    for (i in 0...36) {
      datas.push(new BlockData(0xff0000 + i * 10, 1, 1));
    }

    var grid:BlockGrid = new BlockGrid(12, 40, 20, datas);
    var table:BlockTable = new BlockTable(grid);
    beOnStage(table, true);

    var drawStore:Array<Dynamic> = new Array();
    var start:Point = null;
    var end:Point = null;
    var hitData:BlockHitData;

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
              trace(grid.hit(start, end));
              hitData = grid.hit(start, end);
              if (hitData != null) {
                var hit:Quad = new Quad(4, 4, 0);
                hit.x = hitData.point.x - 2;
                hit.y = hitData.point.y - 2;
                view.addChild(hit);
                grid.removeBlock(hitData.block);
                hitData.block.hit();
                drawStore.push(hit);

                var data:BallData = new BallData(0, 0, 0, 0, 0);
                data.shift(start.x, start.y, end.x, end.y);
                trace(hitData.hitSide);

                switch(hitData.hitSide){
                  case BlockHitSide.Top:
                    data.refrectY(hitData.block.top);
                  case BlockHitSide.Right:
                    data.refrectX(hitData.block.right);
                  case BlockHitSide.Left:
                    data.refrectX(hitData.block.left);
                  case BlockHitSide.Bottom:
                    data.refrectY(hitData.block.bottom);
                  default:
                }
                var refrect:Quad = new Quad(4, 4, 0);
                refrect.x = data.next.x - 2;
                refrect.y = data.next.y - 2;
                view.addChild(refrect);
                drawStore.push(refrect);
                trace('ref p');

                var refline = drawLine(hitData.point, data.next);
                view.addChild(refline);
                drawStore.push(refline);
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

    var radian:Float = Math.atan2(y, x);

    var q:Quad = new Quad(distance, 1, 0);
    q.rotation = radian;
    q.x = start.x;
    q.y = start.y;

    return q;
  }
}
