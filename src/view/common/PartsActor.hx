package view.common;
import starling.display.Quad;

class PartsActor extends BaseActor {
  public var area:Quad;

  public function new() {
    super();
    this.area = new Quad(1, 1, 0, false);
    area.alpha = 0.1;
    this.addChild(area);
  }

  public function initializeArea(?w:Float, ?h:Float) {
    area.width = w == null ? bounds.width : w;
    area.height = h == null ? bounds.height : h;
  }
}
