package model;

import flash.geom.Point;
import initializer.Trace;
import view.Block;
import massive.munit.Assert;
import model.BlockGrid;

class BlockGridTest {
  var grid:BlockGrid;
  var hitGrid:BlockGrid;
  var hitData:BlockHitData;

  public function new() { }

  @BeforeClass
  public function beforeClass():Void {
    Trace.initialize();
    var datas:Array<BlockData> = new Array();
    for (i in 0...20) {
      if (i % 3 == 0) {
        datas.push(null);
        continue;
      }
      datas.push(new BlockData(0xff0000, 1, 1));
    }
    grid = new BlockGrid(4, 100, 50, datas);

    var b1 = new BlockData(0xff0000, 1, 1);
    var b2 = new BlockData(0xff0000, 1, 1);
    var b3 = new BlockData(0xff0000, 1, 1);
    var datas:Array<BlockData> = [
      null, null, null, null,
      null, null, b1, null,
      null, null, null, b3];

    hitGrid = new BlockGrid(4, 200, 50, datas);
  }

  @Test
  public function initialize():Void {
    var block:Block;

    block = grid.pickBlock(0, 0);
    Assert.isNull(block);

    block = grid.pickBlock(1, 0);
    Assert.areEqual(100, block.x);
    Assert.areEqual(0, block.y);

    block = grid.pickBlock(3, 1);
    Assert.areEqual(300, block.x);
    Assert.areEqual(50, block.y);

    block = grid.pickBlock(0, 1);
    Assert.areEqual(0, block.x);
    Assert.areEqual(50, block.y);

    block = grid.pickBlock(0, 2);
    Assert.areEqual(0, block.x);
    Assert.areEqual(100, block.y);
  }


  @Test
  public function getCell():Void {
    var hitGrid:BlockGrid = new BlockGrid(4, 200, 50, []);
    var p:Point = new Point();
    var r:Point = new Point();

    p.setTo(120, 20);
    r = hitGrid.computeCell(p, r);
    Assert.areSame(0, r.x);
    Assert.areSame(0, r.y);

    p.setTo(200, 50);
    r = hitGrid.computeCell(p, r);
    Assert.areSame(1, r.x);
    Assert.areSame(1, r.y);
  }


  @Test
  public function hitTest():Void {

  }

  @Test
  public function hitTestSameCell():Void {
    var hitData:BlockHitData = hit(hitGrid, 0, 0, 0, 0);
    Assert.isNull(hitData);
  }

  @Test
  public function hitTestDownwardSameX1():Void {
    var hitData:BlockHitData = hit(hitGrid, 500, 40, 500, 120);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(50, hitData.point.y);
  }

  @Test
  public function hitTestDownwardSameX2():Void {
    var hitData:BlockHitData = hit(hitGrid, 490, 40, 510, 60);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(50, hitData.point.y);
  }

  @Test
  public function hitTestDownwardSameXEdge():Void {
    var hitData:BlockHitData = hit(hitGrid, 490, 50, 510, 60);
    Assert.isNotNull(hitData);
    Assert.areSame(490, hitData.point.x);
    Assert.areSame(50, hitData.point.y);
  }


  @Test
  public function hitTestUpwardSameX1():Void {
    var hitData:BlockHitData = hit(hitGrid, 500, 120, 500, 40);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }


  @Test
  public function hitTestUpwardSameX2():Void {
    var hitData:BlockHitData = hit(hitGrid, 490, 110, 510, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }

  @Test
  public function hitTestUpwardSameXEdge():Void {
    var hitData:BlockHitData = hit(hitGrid, 490, 100, 510, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(490, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }

  @Test
  public function hitTestRightwardsameY1():Void {
    var hitData:BlockHitData = hit(hitGrid, 390, 70, 410, 70);
    Assert.isNotNull(hitData);
    Assert.areSame(400, hitData.point.x);
    Assert.areSame(70, hitData.point.y);
  }
  
  @Test
  public function hitTestRightwardsameY2():Void {
    var hitData:BlockHitData = hit(hitGrid, 390, 60, 410, 80);
    Assert.isNotNull(hitData);
    Assert.areSame(400, hitData.point.x);
    Assert.areSame(70, hitData.point.y);
  }

  @Test
  public function hitTestRightwardsameYEdge():Void {
    trace('edge');
    var hitData:BlockHitData = hit(hitGrid, 400, 60, 410, 80);
    trace('edge');
    Assert.isNotNull(hitData);
    Assert.areSame(400, hitData.point.x);
    Assert.areSame(60, hitData.point.y);
  }


  @Test
  public function hitTestLeftwardsameY1():Void {
    var hitData:BlockHitData = hit(hitGrid, 610, 70, 590, 70);
    Assert.isNotNull(hitData);
    Assert.areSame(600, hitData.point.x);
    Assert.areSame(70, hitData.point.y);
  }

  @Test
  public function hitTestLeftwardsameY2():Void {
    var hitData:BlockHitData = hit(hitGrid, 610, 60, 590, 80);
    Assert.isNotNull(hitData);
    Assert.areSame(600, hitData.point.x);
    Assert.areSame(70, hitData.point.y);
  }

  @Test
  public function hitTestLeftwardsameYEdge():Void {
    var hitData:BlockHitData = hit(hitGrid, 600, 60, 590, 80);
    Assert.isNotNull(hitData);
    Assert.areSame(600, hitData.point.x);
    Assert.areSame(60, hitData.point.y);
  }

  @Test
  public function hitTestVertical1():Void {
    var hitData:BlockHitData = hit(hitGrid, 390, 40, 410, 60);
    Assert.isNotNull(hitData);
    Assert.areSame(400, hitData.point.x);
    Assert.areSame(50, hitData.point.y);
  }

  @Test
  public function hitTestVertical1_1():Void {
    var hitData:BlockHitData = hit(hitGrid, 610, 40, 590, 60);
    Assert.isNotNull(hitData);
    Assert.areSame(600, hitData.point.x);
    Assert.areSame(50, hitData.point.y);
  }

  @Test
  public function hitTestVertical2():Void {
    var hitData:BlockHitData = hit(hitGrid, 390, 110, 410, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(400, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }

  @Test
  public function hitTestVertical2_1():Void {
    var hitData:BlockHitData = hit(hitGrid, 610, 110, 590, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(600, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }

  private function hit(grid:BlockGrid, ax:Float, ay:Float, bx:Float, by:Float):BlockHitData {
    var a:Point = new Point(ax, ay);
    var b:Point = new Point(bx, by);
    return grid.hitTest(a, b);
  }
}


