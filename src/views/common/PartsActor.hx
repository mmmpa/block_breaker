package views.common;
import starling.display.Quad;

class PartsActor extends BaseActor {
  public var area:Quad = new Quad(1, 1, 0, false);

  public function new() {
    super();
    area.alpha = 0;
    addChild(area);
  }

  override public function deactivate(){
    area.dispose();
    super.deactivate();
  }

  public function initializeArea(?w:Float, ?h:Float) {
    area.width = w == null ? bounds.width : w;
    area.height = h == null ? bounds.height : h;
  }
}
