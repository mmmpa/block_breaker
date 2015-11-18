package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import flash.geom.Point;

using addition.Cell;

class BlockGrid {
  private var blocks:Array<Array<BlockData>>;
  private var blocksNum:Int;
  public var col:Int;
  public var row:Int;
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

    for (ii in 0...row) {
      blocks[ii] = new Array();
      for (i in 0...col) {
        var block:BlockData = datas[col * ii + i];
        if (block == null) {
          blocks[ii][i] = null;
          continue;
        }

        block.realize(i, ii, width, height);
        blocks[ii][i] = block;
        blocksNum++;
      }
    }
  }

  public function allBlock():Array<BlockData> {
    var all:Array<BlockData> = new Array();

    for (ii in 0...row) {
      for (i in 0...col) {
        var block:BlockData = blocks[ii][i];
        if (block != null) {
          all.push(block);
        }
      }
    }

    return all;
  }

  public function pickBlock(x:Int, y:Int):BlockData {
    return blocks[y][x];
  }

  public function hit(start:Point, end:Point):BlockHitData {
    // どのセルにいるか計算する
    startCell = computeCell(start, startCell);
    endCell = computeCell(end, endCell);

    var edgeX:Bool = (start.x % cellWidth) == 0;
    var edgeY:Bool = (start.y % cellHeight) == 0;

    // 同セル内ではヒットは生じない
    if (!edgeX && !edgeY && startCell.isSameCell(endCell)) {
      return null;
    }

    // 初期化
    d.initialize(start, end);

    var pow:Float = getPow(start, end);
    var startIndex = pToIndex(startCell);
    var cellXMovement:Int = startCell.movementX(endCell);
    var cellYMovement:Int = startCell.movementY(endCell);
    var closestX:BlockHitData = null;
    var closestY:BlockHitData = null;
    hitDataX.reset();
    hitDataY.reset();

    // 同じ行もしくは同じ列で移動したときの計算
    // 計算量が少し小さいはずだが、計算が分散するのでよくないかもしれない。
    // 必要なさそうならコメントアウトする。
    /*
    hitData.reset();
    getFirstHitSameLine(start, end, pow, startIndex, edgeX, edgeY, cellXMovement, cellYMovement);
    if (hitData.hitted()) {
      return hitData;
    }
    */
    // ここまで

    // x移動での最短ヒットブロック
    // hitDataXを再利用
    trace('x');
    for (i in (edgeX ? 0 : 1)...cellXMovement + 1) {
      var colNow:Int = Std.int(startCell.x) + (d.isRightward() ? i : -i);
      var hitX:Float = (colNow + (d.isRightward() ? 0 : 1)) * cellWidth;
      var hitY:Float = start.y + shiftY(start.x, hitX, pow);
      var rowNow:Int = yToRow(hitY);

      if (!inGrid(colNow, rowNow)) { continue; }

      hitDataX.block = blocks[rowNow][colNow];
      // 右角ヒット対策
      if (!hitDataX.hitted() && (end.x % cellWidth) == 0 && colNow != 0) {
        hitDataX.block = blocks[rowNow][colNow - 1];
      }

      if (hitDataX.hitted()) {
        hitDataX.hitSide = d.isRightward() ? BlockHitSide.Left : BlockHitSide.Right;
        hitDataX.point.setTo(hitX, hitY);
        closestX = hitDataX;
        break;
      }
    }

    // y移動での最短ヒットブロック
    // hitDataYを再利用
    trace('y');
    for (i in (edgeY ? 0 : 1)...cellYMovement + 1) {
      var rowNow:Int = Std.int(startCell.y) + (d.isDownward() ? i : -i);
      var hitY:Float = (rowNow + (d.isDownward() ? 0 : 1)) * cellHeight;
      var hitX:Float = start.x + shiftX(start.y, hitY, pow);
      var colNow:Int = xToCol(hitX);

      if (!inGrid(colNow, rowNow)) { continue; }

      hitDataY.block = blocks[rowNow][colNow];
      // 右角ヒット対策
      if (!hitDataY.hitted() && (hitX % cellWidth) == 0 && colNow != 0) {
        hitDataY.block = blocks[rowNow][colNow - 1];
      }

      if (hitDataY.hitted()) {
        hitDataY.hitSide = d.isDownward() ? BlockHitSide.Top : BlockHitSide.Bottom;
        hitDataY.point.setTo(hitX, hitY);
        closestY = hitDataY;
        break;
      }
    }
    trace([closestX, closestY]);


    return closest(start, closestX, closestY);
  }

  public function removeBlock(target:BlockData):BlockData {
    var block:BlockData = blocks[target.row][target.col];

    if (block != null) {
      blocksNum--;
      blocks[target.row][target.col] = null;
    }

    return block;
  }

  public function hasBlock():Bool {
    return blocksNum != 0;
  }

  @:extern inline function getFirstHitSameLine(start:Point, end:Point, pow:Float, startIndex:Int, edgeX:Bool, edgeY:Bool, cellXMovement:Int, cellYMovement:Int):BlockHitData {
    if (startCell.isSameX(endCell)) {
      //同列
      for (i in (edgeY ? 0 : 1)...cellYMovement + 1) {
        var indexNow = startIndex + (d.isDownward() ? col * i : -(col * i));
        var rowNow:Int = toRow(indexNow);

        if (!inRow(rowNow)) {
          continue;
        }

        hitData.block = blocks[rowNow][Std.int(startCell.x)];

        if (hitData.hitted()) {
          var hitY:Float = (rowNow + (d.isDownward() ? 0 : 1)) * cellHeight;
          hitPoint.setTo(start.x + shiftX(start.y, hitY, pow), hitY);
          break;
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

        hitData.block = blocks[Std.int(startCell.y)][colNow];

        if (hitData.hitted()) {
          var hitX:Float = (colNow + (d.isRightward() ? 0 : 1)) * cellWidth;
          hitPoint.setTo(hitX, start.y + shiftY(start.x, hitX, pow));
          break;
        }
      }
    }

    return hitData;
  }

  @:extern inline function inGrid(col:Int, row:Int):Bool {
    return inCol(col) && inRow(row);
  }

  @:extern inline function inX(n:Float):Bool {
    return 0 <= n && n <= col * cellWidth;
  }

  @:extern inline function inY(n:Float):Bool {
    return 0 <= n && n <= row * cellHeight;
  }

  @:extern inline function inRow(n:Int):Bool {
    return 0 <= n && n < row;
  }

  @:extern inline function inCol(n:Int):Bool {
    return 0 <= n && n < col;
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

  private function closest(base:Point, a:BlockHitData, b:BlockHitData):BlockHitData {
    if (a == null) {
      return b;
    } else if (b == null) {
      return a;
    }

    var toA:Float = distance(base, a.point);
    var toB:Float = distance(base, b.point);

    return toA < toB ? a : b;
  }

  @:extern inline function distance(start:Point, end:Point):Float {
    var x:Float = end.x - start.x;
    var y:Float = end.y - start.y;
    return Math.sqrt(x * x + y * y);
  }

  @:extern inline function computeCell(point:Point, result:Point):Point {
    result.setTo(xToCol(point.x), yToRow(point.y));
    return result;
  }

  @:extern inline function indexFromPoint(point:Point):Int {
    return toIndex(xToCol(point.x), yToRow(point.y));
  }

  @:extern inline function xToCol(n:Float):Int {
    return Std.int(n / cellWidth);
  }

  @:extern inline function yToRow(n:Float):Int {
    return Std.int(n / cellHeight);
  }

  @:extern inline function toCol(i:Int):Int {
    return i % col;
  }

  @:extern inline function toRow(i:Int):Int {
    return Std.int(i / col);
  }

  @:extern inline function toIndex(x:Int, y:Int):Int {
    return col * y + x;
  }

  @:extern inline function pToIndex(p:Point):Int {
    return toIndex(Std.int(p.x), Std.int(p.y));
  }

}
