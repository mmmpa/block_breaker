package context.test;
import db.Palette;
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
  private var grid:BlockGrid;
  private var table:BlockTable;


  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);

    startAnimation();
    ground.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xffeeff));
    ground.name = 'block hit context';

    lineState = 'ready';

    var col:Int = 20;
    var width:Int = Std.int(Def.stage.stageWidth / col);
    var height:Int = width >> 1;

    var datas:Array<BlockData> = new Array();

    for (ii in 0...50) {
      for (i in 0...col) {
        if (ii > 4 && (ii * 20 + i) % 3 == 0 && i != 0 && i % 4 != 0 && i != 19) {
          datas.push(new BlockData(Palette.random(), 10000, 1));
        } else {
          datas.push(null);
        }
      }
    }

    grid = new BlockGrid(col, width, height, datas);
    table = new BlockTable(grid);
    beOnStage(table, true);

    var drawStore:Array<Dynamic> = new Array();
    var start:Point = null;
    var end:Point = null;
    var hitData:BlockHitData;

    ground.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
      var touch:Touch = e.getTouch(Def.stage);
      var position:Point = touch.getLocation(Def.stage);
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
              trace(grid.hit(start, end));
              hitData = grid.hit(start, end);

              var data:BallData = new BallData(0, 0, 0, 0, 0);
              data.shift(start.x, start.y, end.x, end.y);

              while(hitData != null) {
                var refline = drawLine(start, hitData.point);
                ground.addChild(refline);
                drawStore.push(refline);
                var hit:Quad = new Quad(4, 4, 0);
                hit.x = hitData.point.x - 2;
                hit.y = hitData.point.y - 2;
                ground.addChild(hit);
                drawStore.push(hit);

                switch(hitData.hitSide){
                  case BlockHitSide.Top:
                    data.refrectY(hitData.block.top, hitData.point.x);
                  case BlockHitSide.Right:
                    data.refrectX(hitData.block.right, hitData.point.y);
                  case BlockHitSide.Left:
                    data.refrectX(hitData.block.left, hitData.point.y);
                  case BlockHitSide.Bottom:
                    data.refrectY(hitData.block.bottom, hitData.point.x);
                  default:
                }
                hitData = grid.hit(data.prev, data.next);
                start = data.prev;
                end = data.next;
              }
              var refrect:Quad = new Quad(4, 4, 0);
              refrect.x = data.next.x - 2;
              refrect.y = data.next.y - 2;
              ground.addChild(refrect);
              drawStore.push(refrect);

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
