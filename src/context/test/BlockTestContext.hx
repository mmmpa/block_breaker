package context.test;
import starling.events.TouchPhase;
import addition.Def;
import starling.events.TouchEvent;
import starling.events.Touch;
import starling.events.Event;
import view.Block;
import model.BlockGrid;
import model.BlockData;
import model.RouterProp;
import context.BaseContext;

class BlockTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);

    startAnimation();

    var datas:Array<BlockData> = new Array();
    for (i in 0...20) {
      if (i % 3 == 0) {
        datas.push(null);
        continue;
      }
      datas.push(new BlockData(0xff0000, 1, 1));
    }

    var grid:BlockGrid = new BlockGrid(4, 100, 50, datas);

    beOnStage(grid, true);

    grid.allBlock().map(function(block:Block) {
      block.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent) {
        var touch:Touch = e.getTouch(Def.stage);

        switch(touch.phase){
          case TouchPhase.BEGAN:
            block.deactivate();
            beOnStage(block.splash);
        }
      });
    });
  }
}
