package views.common;
import starling.events.Event;
import starling.display.DisplayObjectContainer;
import contexts.BaseContext;
import starling.display.Sprite;

class BaseActor extends Sprite{
  public var context:BaseContext;

  public function new() {
    super();
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    this.context = context;
    parent.addChild(this);
  }

  public function emit(e:Event){
    context.emit(e);
  }

  public function deactivate() {
    this.context = null;
    removeFromParent();
    removeChildren();
    removeEventListeners();
  }

  public function act():Bool {
    return true;
  }
}
