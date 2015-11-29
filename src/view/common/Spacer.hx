package view.common;
import starling.display.Quad;
class Spacer extends Quad {
  public function new(w:Int, h:Int) {
    super(w, h, 0, false);
    alpha = 0.5;
  }
}
