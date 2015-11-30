package views.blockbreaker;
import contexts.BaseContext;
import models.blockbreaker.BlockData;
import starling.display.DisplayObjectContainer;
import models.blockbreaker.BlockGrid;

using Lambda;

class BlockTable {
  private var grid:BlockGrid;
  private var blocks:Array<Block>;

  public function new(grid:BlockGrid) {
    this.grid = grid;
    this.blocks = new Array();
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer):BlockTable {
    grid.allBlock().iter(function(data:BlockData) {
      var block:Block = Block.create(data);
      context.beOnStage(block, false, parent);
      add(block);
    });

    return this;
  }

  private function add(block:Block) {
    blocks.push(block);
  }

  public function act() {
  }

  public function deactivate() {
    blocks.iter(function(block:Block) {
      block.deactivate();
    });
    blocks = null;
    grid = null;
  }
}
