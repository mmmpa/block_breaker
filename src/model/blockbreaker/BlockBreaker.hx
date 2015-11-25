package model.blockbreaker;
import config.Def;
import config.Configuration;
import flash.geom.Point;
import asset.Se;
import context.BaseContext;

using Lambda;

class BlockBreaker {
  private var field:PlayFieldData;
  private var grid:BlockGrid;

  private var balls:Array<BallData> = new Array();
  private var blocks:Array<BlockData> = new Array();
  private var shocks:Array<ShockData> = new Array();
  private var state:BlockBreakerState;

  public function new(grid:BlockGrid) {
    this.field = new PlayFieldData(0, 0, Def.area.w, Def.area.h);
    this.grid = grid;
  }

  public function deactivate(){
    balls = null;
    blocks = null;
    shocks = null;
  }

  public function hasBall():Bool {
    return balls.length != 0;
  }

  public function noBall():Bool {
    return balls.length == 0;
  }

  public function play(context:BaseContext) {
    // shockの拡張処理処理
    shocks = shocks.filter(function(data:ShockData):Bool {
      data.spread();
      return !data.isCompleted();
    });

    //サウンド再生は一度のみ
    //最後に一度だけ再生
    var playBroken:Bool = false;
    var playHit:Bool = false;
    var playHard:Bool = false;

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
          block.hit();
          if (!block.isAlive()) {
            grid.removeBlock(block);
            playBroken = true;
            if (block.hasBall()) {
              addBall(block.ballP, 70 + Math.floor(Math.random() * 40), block.color);
            }
          } else {
            playHard = true;
          }
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
              data.die();
              loop = false;
              break;
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

    if (Configuration.soundEnabled) {
      if (playBroken) {Se.broken.play();}
      if (playHit) {Se.hit.play();}
      if (playHard) {Se.hard.play();}
    }

    balls = nextBalls;
  }

  public function addShock(p:Point):ShockData {
    var data:ShockData = new ShockData(Std.int(p.x), Std.int(p.y), 2);
    shocks.push(data);
    return data;
  }

  public function addBall(p:Point, degree:Int, color:Int = 0):BallData {
    var data:BallData = new BallData(p.x, p.y, color, 8, degree * Math.PI / 180);
    balls.push(data);
    return data;
  }
}
