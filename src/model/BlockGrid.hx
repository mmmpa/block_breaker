package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import view.Block;
import view.Block;
class BlockGrid {
  private var blocks:Array<Block>;
  private var col:UInt;

  public function new(col:Int, width:Int, height:Int, datas:Array<BlockData>) {
    this.col = col;

    this.blocks = new Array();
    for (i in 0...datas.length) {
      var data:BlockData = datas[i];
      var x:Int = width * (i % col);
      var y:Int = height * Std.int(i / col);
      var block:Block = new Block(width, height, data.color, data.ball, data.life, x, y);
      blocks.push(block);
    }
  }

  public function pickBlock(x:UInt, y:UInt):Block {
    return blocks[col * y + x];
  }
}
