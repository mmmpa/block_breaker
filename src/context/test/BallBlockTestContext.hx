package context.test;
import view.Shock;
import model.ShockHitData;
import model.BlockHitSide;
import model.BlockData;
import model.BlockHitData;
import model.ShockData;
import view.BlockTable;
import db.PlainGame;
import model.BlockGrid;
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
import addition.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;
using addition.NullOr;

class BallBlockTestContext extends BaseContext {
  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;
  private var grid:BlockGrid;
  private var shocks:Array<ShockData> = new Array();
  private var listener:Quad;
  private var table:BlockTable;

public function new(props:RouterProp, insertProps:BallTestProp = null) {
    super(props);
    field = new PlayFieldData(0, 0, Def.stage.stageWidth, Def.stage.stageHeight);
    listener = new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xcccccc);
    ground.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xcccccc));
    ground.addEventListener(TouchEvent.TOUCH, onTouch);


    var col:Int = 20;
    var width:Int = Std.int(Def.stage.stageWidth / col);
    var height:Int = width >> 1;

    var datas:Array<BlockData> = new Array();

    for (ii in 0...50) {
      for (i in 0...col) {
        if (ii > 4 && (ii * 20 + i) % 3 == 0 && i != 0 && i % 4 != 0 && i != 19) {
          datas.push(new BlockData(Palette.random(), 2, 1));
        } else {
          datas.push(null);
        }
      }
    }

    grid = new BlockGrid(col, width, height, datas);
    table = new BlockTable(grid);
    beOnStage(table, true);

    write(play);
    startAnimation();

    var w:Int = Def.stage.stageWidth;
    var h:Int = Def.stage.stageHeight;

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
      for (ii in 0...10) {
        i++;
        var data:BallData = new BallData(random(w), random(h), Palette.random(), Std.int(random(5) + 5), i);
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

  override function deactivate(){
    table.deactivate();
    super.deactivate();
  }

  private function random(n:Float):Float {
    return Std.int(Math.floor(Math.random() * n));
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(Def.stage);
    var position:Point = touch.getLocation(Def.stage);

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

  private function play(context:BaseContext) {
    // shockの拡張処理処理
    shocks = shocks.filter(function(data:ShockData):Bool {
      data.spread();
      return !data.isCompleted();
    });

    // 各ボールの衝突処理
    var data:BallData;
    var nextBalls:Array<BallData> = new Array();
    while (balls.length != 0) {
      data = balls.pop();

      data.ready();
      // 衝突が生じなくなるまで繰り返す
      var loop:Bool = true;
      while (loop) {
        // ブロック処理
        var blockHit:BlockHitData = grid.hit(data.prev, data.next);
        if (blockHit != null) {
          var block:BlockData = blockHit.block;
          //block.hit();
          switch(blockHit.hitSide){
            case BlockHitSide.Top:
              data.refrectY(blockHit.block.top);
            case BlockHitSide.Right:
              data.refrectX(blockHit.block.right);
            case BlockHitSide.Left:
              data.refrectX(blockHit.block.left);
            case BlockHitSide.Bottom:
              data.refrectY(blockHit.block.bottom);
            default:
          }
          continue;
        }

        // ショック処理
        var shocked:Bool = false;
        shocks.iter(function(shock:ShockData) {
          var hitData:ShockHitData = shock.hit(data.prev, data.next);
          if (hitData != null && data.hittedId != hitData.id) {
            data.hittedId = hitData.id;
            data.resetRadian(hitData.radian);
            data.shift(hitData.point.x, hitData.point.y, hitData.next.x, hitData.next.y);
            shocked = true;
          }
        });
        if (shocked) {continue;}

        // 外壁処理
        var out:FieldOutSide = field.isOutOfBound(data.next);
        loop = false;
        while (out != FieldOutSide.InField) {
          loop = true;
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
      }

      data.move();

      if (data.isAlive()) {
        nextBalls.push(data);
      };
    }

    balls = nextBalls;
  }

  private function addBall(p:Point) {
    var data:BallData = new BallData(p.x, p.y, 0xff0000, 10, Math.floor(Math.random() * 360));
    var ball:Ball = Ball.create(data);
    balls.push(data);
    beOnStage(ball);
  }
}