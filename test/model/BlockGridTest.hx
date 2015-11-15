package model;

import initializer.Trace;
import view.Block;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import model.BlockGrid;
import massive.munit.util.Timer;

class BlockGridTest {
  var instance:BlockGrid;

  public function new() {

  }

  @BeforeClass
  public function beforeClass():Void {
    Trace.initialize();
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
  public function testExample():Void {
    var datas:Array<BlockData> = new Array();
    for (i in 0...20) {
      if(i % 3 == 0){
        datas.push(null);
        continue;
      }
      datas.push(new BlockData(0xff0000, 1, 1));
    }
    trace(datas);

    var grid:BlockGrid = new BlockGrid(4, 100, 50, datas);

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
}
