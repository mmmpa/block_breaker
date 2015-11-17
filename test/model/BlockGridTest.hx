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
  var blocks:Array<BlockData>;

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
    var b4 = new BlockData(0xff0000, 1, 1);
    var b5 = new BlockData(0xff0000, 1, 1);
    var b6 = new BlockData(0xff0000, 1, 1);
    blocks = new Array();
    blocks[1] = b1;
    blocks[2] = b2;
    blocks[3] = b3;
    blocks[4] = b4;
    blocks[5] = b5;
    blocks[6] = b6;
    var datas:Array<BlockData> = [
      null, null, null, null,
      null, null, b1, null,
      null, null, null, b3,
      b4, null, null, null,
      null, null, b5, b6];

    hitGrid = new BlockGrid(4, 200, 50, datas);
  }


  @Test
  public function initialize():Void {
    var block:BlockData;

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
  public function hitTestPremise():Void {
    Assert.areEqual(4, hitGrid.col);
    Assert.areEqual(5, hitGrid.row);
  }

  @Test
  public function hitTest1():Void {
    var hitData:BlockHitData = hit(hitGrid, 0, 200, 0, 199);
    Assert.areEqual(blocks[4], hitData.block);
  }

  @Test
  public function hitTestOutOfArea1():Void {
    var hitData:BlockHitData = hit(hitGrid, 0, 210, -10, 200);
    Assert.isNull(hitData);
  }

  @Test
  public function hitTestOutOfArea2():Void {
    var hitData:BlockHitData = hit(hitGrid, 795, 160, 815, 140);
    trace(hitData);
    Assert.isNull(hitData);
  }

  @Test
  public function hitTest3():Void {
    var hitData:BlockHitData = hit(hitGrid, 10, 150, 0, 150);
    Assert.areEqual(blocks[4], hitData.block);
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
    var hitData:BlockHitData = hit(hitGrid, 400, 60, 410, 80);
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

  @Test
  public function hitTestLongShot_1():Void {
    var hitData:BlockHitData = hit(hitGrid, 300, 250, 900, 240);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[5], hitData.block);
  }

  @Test
  public function hitTestLongShot_2():Void {
    var hitData:BlockHitData = hit(hitGrid, 900, 250, 300, 240);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[6], hitData.block);
  }
  @Test
  public function hitTestLongShot_3():Void {
    var hitData:BlockHitData = hit(hitGrid, 801, 150, 399, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[3], hitData.block);
  }

  @Test
  public function hitTestLongShot_4():Void {
    var hitData:BlockHitData = hit(hitGrid, 399, 90, 801, 150);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[1], hitData.block);
  }

  @Test
  public function hitTestLongShot_5():Void {
    var hitData:BlockHitData = hit(hitGrid, 800, 151, 590, 49);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[3], hitData.block);
  }

  @Test
  public function hitTestLongShot_6():Void {
    var hitData:BlockHitData = hit(hitGrid, 590, 49, 800, 151);
    Assert.isNotNull(hitData);
    Assert.areSame(blocks[1], hitData.block);
  }


  private function hit(grid:BlockGrid, ax:Float, ay:Float, bx:Float, by:Float):BlockHitData {
    var a:Point = new Point(ax, ay);
    var b:Point = new Point(bx, by);
    return grid.hit(a, b);
  }
}
