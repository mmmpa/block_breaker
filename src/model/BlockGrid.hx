package model;
/*

ブロックの配置の定義やブロックの衝突などを計算する

 */
import starling.display.DisplayObjectContainer;
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
      if (data == null) {
        blocks.push(null);
        continue;
      }
      var x:Int = width * (i % col);
      var y:Int = height * Std.int(i / col);
      var block:Block = new Block(width, height, data.color, data.ball, data.life, x, y);
      blocks.push(block);
    }
  }

  public function allBlock():Array<Block>{
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
    return blocks[col * y + x];
  }

  public function activate(parent:DisplayObjectContainer) {
    for (i in 0...blocks.length) {
      var block:Block = blocks[i];
      if (block != null) {
        parent.addChild(block);
      }
    }
  }

  public function deactivate(){
    this.blocks = null;
  }
}
