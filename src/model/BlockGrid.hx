package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import flash.geom.Point;
import starling.display.DisplayObjectContainer;
import view.Block;
import view.Block;

class BlockGrid {
  private var blocks:Array<Block>;
  private var blocksNum:UInt;
  private var col:UInt;
  private var row:UInt;
  private var hitPoint:Point = new Point();
  private var hitData:BlockHitData;
  private var cellWidth:Int;
  private var cellHeight:Int;
  private var startCell:Point = new Point();
  private var endCell:Point = new Point();

  public function new(col:Int, width:Int, height:Int, datas:Array<BlockData>) {
    this.col = col;
    this.row = Std.int(Math.ceil(datas.length / col));
    this.blocksNum = 0;
    this.blocks = new Array();
    this.cellWidth = width;
    this.cellHeight = height;
    this.hitData = new BlockHitData(null, hitPoint);

    for (i in 0...datas.length) {
      var data:BlockData = datas[i];
      if (data == null) {
        blocks.push(null);
        continue;
      }
      var x:Int = width * (i % col);
      var y:Int = height * Std.int(i / col);
      var block:Block = new Block(width, height, data.color, data.ball, data.life, x, y);
      blocks.push(block);
      blocksNum++;
    }
  }

  public function allBlock():Array<Block> {
    var all:Array<Block> = new Array();

    for (i in 0...blocks.length) {
      var block:Block = blocks[i];
      if (block != null) {
        all.push(block);
      }
    }

    return all;
  }

  public function pickBlock(x:UInt, y:UInt):Block {
    return blocks[index(x, y)];
  }

  public function hitTest(start:Point, end:Point):BlockHitData {
    hitPoint.setTo(-1, -1);
    // どのセルにいるか計算する
    startCell = computeCell(start, startCell);
    endCell = computeCell(end, endCell);
    // 同セル内ではヒットは生じない
    if (isSameCell(startCell, endCell)) {
      trace('same cell');
      return null;
    }

    // 線の方向を計算する
    var direction:Direction = detectDirection(start, end);
    // どのセルにヒットしうるか計算する

    //同列、同行の場合
    if (isSameX(startCell, endCell)) {
      trace('same X');
      //同列
      if (isDownWard(direction)) {
        trace(['downward', startCell, endCell, Std.int(endCell.y - startCell.y)]);
        // += col
        var startIndex = indexByPoint(startCell);
        for (i in 1...(Std.int(endCell.y - startCell.y)) + 1) {
          var block:Block = blocks[startIndex + col * i];
          if (block != null) {
            hitData.block = block;
            var distance:Float = block.y - start.y;
            var rate:Float = (end.x - start.x) / (end.y - start.y);
            trace([rate, distance]);
            var shiftX:Float = distance * rate;
            hitPoint.setTo(start.x + shiftX, block.y);
            return hitData;
          }
        }
      } else {
        trace('upward');
        // -= col
        var startIndex = indexByPoint(startCell);
        for (i in 1...(Std.int(startCell.y - endCell.y)) + 1) {
          var block:Block = blocks[startIndex - col * i];
          if (block != null) {
            hitData.block = block;
            var distance:Float = start.y - (block.y + cellHeight);
            var rate:Float = (end.x - start.x) / (start.y - end.y);
            trace(rate);
            var shiftX:Float = distance * rate;
            hitPoint.setTo(start.x + shiftX, block.y + cellHeight);
            return hitData;
          }
        }
      }
    } else if (isSameY(startCell, endCell)) {
      //同行
      if (isRightWard(direction)) {
        // ++
      } else {
        // --
      }
    }
    //// ブロックがなければnull
    // ヒット位置を計算する

    return hitData;
  }

  public function detectDirection(start:Point, end:Point):Direction {
    if (start.x < end.x) {
      if (start.y < end.y) {
        return Direction.RIGHT_DOWN;
      } else {
        return Direction.RIGHT_UP;
      }
    } else {
      if (start.y < end.y) {
        return Direction.LEFT_DOWN;
      } else {
        return Direction.LEFT_UP;
      }
    }
  }

  public function isRightWard(direction:Direction):Bool {
    return direction == Direction.RIGHT_DOWN || direction == Direction.RIGHT_UP;
  }

  public function isDownWard(direction:Direction):Bool {
    return direction == Direction.LEFT_DOWN || direction == Direction.RIGHT_DOWN;
  }

  public function isSameCell(start:Point, end:Point):Bool {
    return start.x == end.x && start.y == end.y;
  }

  public function isSameY(start:Point, end:Point):Bool {
    return start.y == end.y;
  }

  public function isSameX(start:Point, end:Point):Bool {
    return start.x == end.x;
  }


  public function computeCell(point:Point, result:Point):Point {
    var x:Int = Std.int(point.x / cellWidth);
    var y:Int = Std.int(point.y / cellHeight);
    result.setTo(x, y);
    return result;
  }

  public function index(x:Int, y:Int):UInt {
    return col * y + x;
  }

  public function indexByPoint(p:Point):UInt {
    return index(Std.int(p.x), Std.int(p.y));
  }

  public function removeBlock(x:UInt, y:UInt):Block {
    var block:Block = blocks[index(x, y)];
    if (block != null) {
      blocksNum--;
      blocks[index(x, y)] = null;
    }

    return block;
  }

  public function hasBlock():Bool {
    return blocksNum != 0;
  }

  public function getFirstHit(start:Point, end:Point):Block {
    return null;
  }

  public function activate(parent:DisplayObjectContainer) {
    for (i in 0...blocks.length) {
      var block:Block = blocks[i];
      if (block != null) {
        parent.addChild(block);
      }
    }
  }

  public function deactivate() {
    this.blocks = null;
  }
}
