package contexts.test;
import views.blockbreaker.Calm;
import views.NormalBg;
import views.blockbreaker.Shock;
import models.blockbreaker.ShockHitData;
import models.blockbreaker.BlockHitSide;
import models.blockbreaker.BlockData;
import models.blockbreaker.BlockHitData;
import models.blockbreaker.ShockData;
import views.blockbreaker.BlockTable;
import models.blockbreaker.BlockGrid;
import assets.BlockFont;
import dbs.Palette;
import models.test.BallTestProp;
import starling.text.TextField;
import models.blockbreaker.FieldOutSide;
import models.blockbreaker.PlayFieldData;
import models.blockbreaker.BallData;
import views.blockbreaker.Ball;
import starling.events.Event;
import starling.events.TouchPhase;
import starling.display.Quad;
import configs.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import models.RouterProp;

using Lambda;
using additions.Support;

class BallBlockTestContext extends BaseContext {
  private var balls:Array<BallData> = new Array();
  private var field:PlayFieldData;
  private var grid:BlockGrid;
  private var calm:Calm = new Calm();
  private var shocks:Array<ShockData> = new Array();
  private var listener:Quad;
  private var table:BlockTable;

  public function new(props:RouterProp, insertProps:BallTestProp = null) {
    super(props);

    this.y = Def.area.y;
    field = new PlayFieldData(0, 0, Def.area.w, Def.area.h);
    listener = new NormalBg();
    //addChild(new Quad(Def.area.w, Def.area.h, Def.testBg));
    //addEventListener(TouchEvent.TOUCH, onTouch);
    addChild(calm);

    this.touchable = false;
    var col:Int = 20;
    var width:Int = Std.int(Def.area.w / col);
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
    addActor(table, true, calm);

    addTask(play);
    startAnimation();

    var w:Int = Def.area.w;
    var h:Int = Def.area.h;

    var limitation:Int = insertProps.be() ? insertProps.limitation : 10;
    var i:Int = 0;
    var fn:Dynamic = null;
    var tf:TextField = new TextField(w, 50, '');
    tf.y = (h + 50) >> 1;
    tf.fontName = BlockFont.name;
    tf.fontSize = 40;
    //addChild(tf);
    addEventListener(Event.ENTER_FRAME, fn = function(e:Event) {
      for (ii in 0...100) {
        i++;
        var data:BallData = new BallData(random(w), random(h), Palette.random(), Std.int(random(5) + 5), i);
        var ball:Ball = Ball.create(data);
        balls.push(data);
        addActor(ball, false, calm);
      }
      tf.text = Std.string(i);
      if (i >= limitation) {
        removeEventListener(Event.ENTER_FRAME, fn);
      }
    });
  }

  override function deactivate() {
    balls = null;
    shocks = null;
    table.deactivate();
    super.deactivate();
  }

  private function random(n:Float):Float {
    return Std.int(Math.floor(Math.random() * n));
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(this);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        var position:Point = touch.getLocation(this);
        shock(position);
    }
  }

  private function shock(p:Point) {
    var data:ShockData = new ShockData(Std.int(p.x), Std.int(p.y), 2);
    var shock:Shock = new Shock(data);
    shocks.push(data);
    addActor(shock);
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
              data.refrectY(blockHit.block.top, blockHit.point.x);
            case BlockHitSide.Right:
              data.refrectX(blockHit.block.right, blockHit.point.y);
            case BlockHitSide.Left:
              data.refrectX(blockHit.block.left, blockHit.point.y);
            case BlockHitSide.Bottom:
              data.refrectY(blockHit.block.bottom, blockHit.point.x);
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
    addActor(ball);
  }
}
