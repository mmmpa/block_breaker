package context.test;
import view.Splash;
import starling.events.Event;
import starling.events.TouchPhase;
import starling.display.Quad;
import addition.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;
class PlayFieldTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    view.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xcccccc));
    view.addEventListener(TouchEvent.TOUCH, onTouch);

    startAnimation();
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(Def.stage);
    var position:Point = touch.getLocation(Def.stage);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        splash(position);
    }
  }

  private function splash(p:Point) {
    var splash:Splash = new Splash(Def.splashFrame, Def.splashSize, 0xff0000, Std.int(p.x), Std.int(p.y));
    actors.push(splash.activate(this, view));
  }
}