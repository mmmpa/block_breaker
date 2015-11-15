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
class SplashTestContext extends BaseContext {
  private var actors:Array<Dynamic> = new Array();

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    view.addChild(new Quad(Def.stage.stageWidth, Def.stage.stageHeight, 0xcccccc));
    view.addEventListener(TouchEvent.TOUCH, onTouch);

    view.addEventListener(Event.ENTER_FRAME, animate);
  }

  private function animate(e:Event) {
    var nextStore:Array<Dynamic> = new Array();

    for (i in 0...actors.length) {
      var actor:Dynamic = actors[i];
      if (actor.act()) {
        nextStore.push(actor);
      }else{
        actor.deactivate();
      }
    }

    actors = nextStore;
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
    var splash:Splash = new Splash(10, 16, 0xff0000, Std.int(p.x), Std.int(p.y));
    actors.push(splash.activate(view));
  }
}
