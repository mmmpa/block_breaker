package model;

import view.Block;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import model.BlockGrid;

class BlockGridTest {
  var instance:BlockGrid;

  public function new() {

  }

  @BeforeClass
  public function beforeClass():Void {
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
    for(i in 0...20){
      datas.push(new BlockData(0xff0000, 1, 1));
    }
    trace(datas);

    var grid:BlockGrid = new BlockGrid(4, 100, 50, datas);

    var block:Block = grid.pickBlock(1,4);

    trace(block);
  }
}