package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import flash.geom.Point;
import starling.display.DisplayObjectContainer;
import view.Block;

using addition.Cell;

class BlockGrid {
  private var blocks:Array<Block>;
  private var blocksNum:UInt;
  private var col:UInt;
  private var row:UInt;
  private var cellWidth:Int;
  private var cellHeight:Int;

  // 再利用オブジェクト
  private var hitPoint:Point = new Point();
  private var hitPointX:Point = new Point();
  private var hitPointY:Point = new Point();
  private var hitData:BlockHitData;
  private var hitDataX:BlockHitData;
  private var hitDataY:BlockHitData;
  private var startCell:Point = new Point();
  private var endCell:Point = new Point();
  private var d:Direction = new Direction();

  public function new(col:Int, width:Int, height:Int, datas:Array<BlockData>) {
    this.col = col;
    this.row = Std.int(Math.ceil(datas.length / col));
    this.blocksNum = 0;
    this.blocks = new Array();
    this.cellWidth = width;
    this.cellHeight = height;
    this.hitData = new BlockHitData(null, hitPoint);
    this.hitDataX = new BlockHitData(null, hitPointX);
    this.hitDataY = new BlockHitData(null, hitPointY);

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
    return blocks[toIndex(x, y)];
  }

  public function hitTest(start:Point, end:Point):BlockHitData {
    // どのセルにいるか計算する
    startCell = computeCell(start, startCell);
    endCell = computeCell(end, endCell);

    // 同セル内ではヒットは生じない
    if (startCell.isSameCell(endCell)) {
      return null;
    }

    // 初期化
    hitData.reset();
    d.initialize(start, end);

    var pow:Float = getPow(start, end);
    var startIndex = pToIndex(startCell);

    // 実計算
    if (startCell.isSameX(endCell)) {
      //同列
      if (d.isDownward) {
        for (i in 1...(Std.int(endCell.y - startCell.y)) + 1) {
          var indexNow = startIndex + col * i;
          hitData.block = blocks[indexNow];

          if (hitData.hitted()) {
            var hitY:Float = toRow(indexNow) * cellHeight;
            hitPoint.setTo(start.x + shiftX(start.y, hitY, pow), hitY);
            return hitData;
          }
        }
      } else {
        for (i in 1...(Std.int(startCell.y - endCell.y)) + 1) {
          var indexNow = startIndex - col * i;
          hitData.block = blocks[indexNow];

          if (hitData.hitted()) {
            var hitY:Float = (toRow(indexNow) + 1) * cellHeight;
            hitPoint.setTo(start.x + shiftX(start.y, hitY, pow), hitY);
            return hitData;
          }
        }
      }
    } else if (startCell.isSameY(endCell)) {
      //同行
      if (d.isRightward) {
        for (i in 1...(Std.int(endCell.x - startCell.x)) + 1) {
          var indexNow = startIndex + i;
          hitData.block = blocks[indexNow];

          if (hitData.hitted()) {
            var hitX:Float = toCol(indexNow) * cellWidth;
            hitPoint.setTo(hitX, start.y + shiftY(start.x, hitX, pow));
            return hitData;
          }
        }
      } else {
        for (i in 1...(Std.int(startCell.x - endCell.x)) + 1) {
          var indexNow = startIndex - i;
          hitData.block = blocks[indexNow];

          if (hitData.hitted()) {
            var hitX:Float = (toCol(indexNow) + 1) * cellWidth;
            hitPoint.setTo(hitX, start.y + shiftY(start.x, hitX, pow));
            return hitData;
          }
        }
      }
    } else {
      var closestX:BlockHitData = null;
      var closestY:BlockHitData = null;
      // 普通のヒット判定
      // x移動での最短ヒットブロック
      if (d.isRightward) {
      } else {

      }
      // y移動での最短ヒットブロック
      if (d.isDownward) {
      } else {

      }
    }
    //// ブロックがなければnull
    // ヒット位置を計算する

    return hitData;
  }

  public function shiftY(startX:Float, endX:Float, pow:Float) {
    return (endX - startX) / pow;
  }

  public function shiftX(startY:Float, endY:Float, pow:Float) {
    return (endY - startY) * pow;
  }

  //pow y移動時のx移動距離

  public function getPow(start:Point, end:Point):Float {
    return (end.x - start.x) / (end.y - start.y);
  }

  public function computeCell(point:Point, result:Point):Point {
    var x:Int = Std.int(point.x / cellWidth);
    var y:Int = Std.int(point.y / cellHeight);
    result.setTo(x, y);
    return result;
  }

  public function toCol(i:Int):Int {
    return i % col;
  }

  public function toRow(i:Int):Int {
    return Std.int(i / col);
  }

  public function toIndex(x:Int, y:Int):UInt {
    return col * y + x;
  }

  public function pToIndex(p:Point):UInt {
    return toIndex(Std.int(p.x), Std.int(p.y));
  }

  public function removeBlock(x:UInt, y:UInt):Block {
    var block:Block = blocks[toIndex(x, y)];
    if (block != null) {
      blocksNum--;
      blocks[toIndex(x, y)] = null;
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
