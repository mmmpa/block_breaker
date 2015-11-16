package model;

import flash.geom.Point;
import initializer.Trace;
import view.Block;
import massive.munit.Assert;
import model.BlockGrid;

class BlockGridTest {
  var grid:BlockGrid;

  public function new() {

  }

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
  }

  @AfterClass
  public function afterClass():Void {
  }

  @Before
  public function setup():Void {
  }


  @After
  public function tearDown():Void {
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
    var b1 = new BlockData(0xff0000, 1, 1);
    var b2 = new BlockData(0xff0000, 1, 1);
    var b3 = new BlockData(0xff0000, 1, 1);
    var datas:Array<BlockData> = [
      null, null, null, null,
      null, null, b1, b2,
      null, null, null, b3];

    var hitGrid:BlockGrid = new BlockGrid(4, 200, 50, datas);
    var hitData:BlockHitData;

    for(i in 0...1){
      trace(i);
    }

    hitData = hit(hitGrid, 0, 0, 0, 0);
    Assert.isNull(hitData);

    trace('///////////////// 1');
    hitData = hit(hitGrid, 500, 40, 500, 120);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(50, hitData.point.y);

    trace('///////////////// 2');
    hitData = hit(hitGrid, 490, 40, 510, 60);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(50, hitData.point.y);

    trace('///////////////// 3');
    hitData = hit(hitGrid, 500, 120, 500, 40);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(100, hitData.point.y);

    trace('///////////////// 4');
    hitData = hit(hitGrid, 490, 110, 510, 90);
    Assert.isNotNull(hitData);
    Assert.areSame(500, hitData.point.x);
    Assert.areSame(100, hitData.point.y);
  }
  
  private function hit(grid:BlockGrid, ax:Float, ay:Float, bx:Float, by:Float):BlockHitData {
    var a:Point = new Point(ax, ay);
    var b:Point = new Point(bx, by);
    return grid.hitTest(a, b);
  }
}


