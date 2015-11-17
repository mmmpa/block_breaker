package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import flash.geom.Point;
import starling.display.DisplayObjectContainer;
import view.Block;

using addition.Cell;

class BlockGrid {
  private var blocks:Array<BlockData>;
  private var blocksNum:UInt;
  private var col:Int;
  private var row:Int;
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
      var block:BlockData = datas[i];
      if (block == null) {
        blocks.push(null);
        continue;
      }

      var cellCol:Int = i % col;
      var cellRow:Int = Std.int(i / col);
      block.realize(cellCol, cellRow, width, height);
      blocks.push(block);
      blocksNum++;
    }
  }

  public function allBlock():Array<BlockData> {
    var all:Array<BlockData> = new Array();

    for (i in 0...blocks.length) {
      var block:BlockData = blocks[i];
      if (block != null) {
        all.push(block);
      }
    }

    return all;
  }

  public function pickBlock(x:UInt, y:UInt):BlockData {
    return blocks[toIndex(x, y)];
  }

  public function hitTest(start:Point, end:Point):BlockHitData {
    // どのセルにいるか計算する
    startCell = computeCell(start, startCell);
    endCell = computeCell(end, endCell);

    var edgeX:Bool = (start.x % cellWidth) == 0;
    var edgeY:Bool = (start.y % cellHeight) == 0;

    trace([edgeX, edgeY]);
    // 同セル内ではヒットは生じない
    if (!edgeX && !edgeY && startCell.isSameCell(endCell)) {
      trace('same');
      return null;
    }

    // 初期化
    hitData.reset();
    hitDataX.reset();
    hitDataY.reset();
    d.initialize(start, end);

    var pow:Float = getPow(start, end);
    var startIndex = pToIndex(startCell);
    var cellXMovement:Int = startCell.movementX(endCell);
    var cellYMovement:Int = startCell.movementY(endCell);
    // 実計算
    /*
    // edgeの場合はどちらも起こる
    if (startCell.isSameX(endCell)) {
      //同列
      for (i in (edgeY ? 0 : 1)...cellYMovement + 1) {
        var indexNow = startIndex + (d.isDownward() ? col * i : -(col * i));
        var rowNow:Int = toRow(indexNow);

        if (!inRow(rowNow)) {
          continue;
        }

        hitData.block = blocks[indexNow];

        if (hitData.hitted()) {
          var hitY:Float = (rowNow + (d.isDownward() ? 0 : 1)) * cellHeight;
          hitPoint.setTo(start.x + shiftX(start.y, hitY, pow), hitY);
          return hitData;
        }
      }
    }

    // edgeの場合はどちらも起こる
    if (startCell.isSameY(endCell)) {
      //同行
      for (i in (edgeX ? 0 : 1)...cellXMovement + 1) {
        var indexNow = startIndex + (d.isRightward() ? i : -i);
        var colNow:Int = toCol(indexNow);

        if (!inCol(colNow)) {
          continue;
        }

        hitData.block = blocks[indexNow];

        if (hitData.hitted()) {
          var hitX:Float = (colNow + (d.isRightward() ? 0 : 1)) * cellWidth;
          hitPoint.setTo(hitX, start.y + shiftY(start.x, hitX, pow));
          return hitData;
        }
      }
    }
    */

    var closestX:BlockHitData = null;
    var closestY:BlockHitData = null;
    // x移動での最短ヒットブロック
    for (i in (edgeX ? 0 : 1)...cellXMovement + 1) {
      var indexNow = startIndex + (d.isRightward() ? i : -i);
      var colNow:Int = toCol(indexNow);

      if (!inCol(colNow)) {
        continue;
      }

      var hitX:Float = (colNow + (d.isRightward() ? 0 : 1)) * cellWidth;
      var hitY:Float = start.y + shiftY(start.x, hitX, pow);

      hitDataX.point.setTo(hitX, hitY);
      var targetIndex:Int = indexFromPoint(hitDataX.point) + (d.isRightward() ? 0 : -1);
      hitDataX.block = blocks[targetIndex];
      // 右角ヒット対策
      if (!hitDataX.hitted() && (hitX % cellWidth) == 0 && toCol(targetIndex) != 0) {
        hitDataX.block = blocks[targetIndex - 1];
      }

      if (hitDataX.hitted()) {
        hitDataX.point.setTo(hitX, hitY);
        closestX = hitDataX;
        break;
      }
    }
    // y移動での最短ヒットブロック
    for (i in (edgeY ? 0 : 1)...cellYMovement + 1) {
      var indexNow = startIndex + (d.isDownward() ? col * i : -(col * i));
      var rowNow:Int = toRow(indexNow);

      if (!inRow(rowNow)) {
        continue;
      }

      var hitY:Float = (rowNow + (d.isDownward() ? 0 : 1)) * cellHeight;
      var hitX:Float = start.x + shiftX(start.y, hitY, pow);

      hitDataY.point.setTo(hitX, hitY);
      var targetIndex:Int = indexFromPoint(hitDataY.point) + (d.isDownward() ? 0 : -col);
      hitDataY.block = blocks[targetIndex];
      // 右角ヒット対策
      if (!hitDataY.hitted() && (hitX % cellWidth) == 0 && toCol(targetIndex) != 0) {
        hitDataY.block = blocks[targetIndex - 1];
      }

      if (hitDataY.hitted()) {
        hitDataY.point.setTo(hitX, hitY);
        closestY = hitDataY;
        break;
      }
    }

    // 距離比較
    if (closestX != null && closestY != null) {
      return closestX;
    } else if (closestX != null) {
      return closestX;
    } else if (closestY != null) {
      return closestY;
    }
    //// ブロックがなければnull
    // ヒット位置を計算する

    return null;
  }

  @:extern inline function inRow(r:Int):Bool {
    return 0 <= r && r <= row;
  }

  @:extern inline function inCol(c:Int):Bool {
    return 0 <= c && c <= col;
  }

  @:extern inline function shiftY(startX:Float, endX:Float, pow:Float) {
    return (endX - startX) / pow;
  }

  @:extern inline function shiftX(startY:Float, endY:Float, pow:Float) {
    return (endY - startY) * pow;
  }

  @:extern inline function getPow(start:Point, end:Point):Float {
    return (end.x - start.x) / (end.y - start.y);
  }

  public function computeCell(point:Point, result:Point):Point {
    var x:Int = Std.int(point.x / cellWidth);
    var y:Int = Std.int(point.y / cellHeight);
    result.setTo(x, y);
    return result;
  }

  public function indexFromPoint(point:Point):Int {
    var x:Int = Std.int(point.x / cellWidth);
    var y:Int = Std.int(point.y / cellHeight);

    return toIndex(x, y);
  }

  @:extern inline function toCol(i:Int):Int {
    return i % col;
  }

  @:extern inline function toRow(i:Int):Int {
    return Std.int(i / col);
  }

  @:extern inline function toIndex(x:Int, y:Int):UInt {
    return col * y + x;
  }

  @:extern inline function pToIndex(p:Point):UInt {
    return toIndex(Std.int(p.x), Std.int(p.y));
  }

  public function removeBlock(x:UInt, y:UInt):BlockData {
    var block:BlockData = blocks[toIndex(x, y)];
    if (block != null) {
      blocksNum--;
      blocks[toIndex(x, y)] = null;
    }

    return block;
  }

  public function hasBlock():Bool {
    return blocksNum != 0;
  }

  public function getFirstHit(start:Point, end:Point):BlockData {
    return null;
  }
}
