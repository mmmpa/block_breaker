package view.common;
import starling.display.DisplayObjectContainer;
import context.BaseContext;
import starling.display.Sprite;

class BaseActor extends Sprite{
  public function new() {
    super();
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
  }

  public function deactivateToo() {
  }

  public function deactivate() {
    deactivateToo();
    this.removeEventListeners();
    removeFromParent();
  }

  public function act():Bool {
    return true;
  }
}
