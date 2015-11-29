package model.blockbreaker;
import model.blockbreaker.BallData;
import config.Def;
import flash.geom.Point;

using Lambda;
using addition.Support;

typedef BlockBreakerOption = {
  var id:String;
  var grid:BlockGrid;
  var speed:Int;
  var field:PlayFieldData;
}

class BlockBreaker {
  public var id:String;
  private var field:PlayFieldData;
  private var grid:BlockGrid;
  private var speed:Int;

  private var balls:Array<BallData> = new Array();
  private var ballsNum:Int = 0;
  private var blocks:Array<BlockData> = new Array();
  private var shocks:Array<ShockData> = new Array();
  public var status:BlockBreakerPlayingState = new BlockBreakerPlayingState();
  public var score:Int = 0;
  public var scoreRate:Int = 1;

  public function new(option:BlockBreakerOption) {
    this.deploy(option);
  }

  public function deactivate() {
    balls = null;
    blocks = null;
    shocks = null;
  }

  public function start() {
    status.state = BlockBreakerState.Playing;
  }

  public function hasBall():Bool {
    return balls.length != 0;
  }

  public function noBall():Bool {
    return balls.length == 0;
  }

  public function play():BlockBreakerPlayingState {
    // shockの拡張処理処理
    shocks = shocks.filter(function(data:ShockData):Bool {
      data.spread();
      return !data.isCompleted();
    });

    status.blockBroken = false;
    status.blockHitted = false;

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
            addScore(block);
            grid.removeBlock(block);
            status.blockBroken = true;
            if (block.hasBall()) {
              var newBall:BallData = addBall(block.ballP, 70 + Math.floor(Math.random() * 40), block.color);
              status.newBalls.push(newBall);
            }
          } else {
            status.blockHitted = true;
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

    balls = nextBalls;
    ballsNum = balls.length;
    scoreRate = Std.int(ballsNum * ballsNum);
    if (noBall()) {
      status.state = BlockBreakerState.Played;
    } else if (!grid.hasBlock()) {
      status.state = BlockBreakerState.Passed;
    }
    return status;
  }

  public function addScore(block:BlockData) {
    score += block.score * scoreRate;
  }

  public function addShock(p:Point):ShockData {
    var data:ShockData = new ShockData(Std.int(p.x), Std.int(p.y), 2);
    shocks.push(data);
    return data;
  }

  public function addBall(p:Point, degree:Int, color:Int = 0):BallData {
    var data:BallData = new BallData(p.x, p.y, color, speed, degree * Math.PI / 180);
    balls.push(data);
    return data;
  }
}
