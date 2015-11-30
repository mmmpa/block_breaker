package contexts.test;
import views.NormalBg;
import views.blockbreaker.Splash;
import starling.events.TouchPhase;
import starling.display.Quad;
import configs.Def;
 import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import models.RouterProp;
class SplashTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;
    ground.addChild(new NormalBg());
    ground.addEventListener(TouchEvent.TOUCH, onTouch);

    startAnimation();
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);
    var position:Point = touch.getLocation(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        splash(position);
    }
  }

  private function splash(p:Point) {
    var splash:Splash = new Splash(Def.splashFrame, Def.splashSize, 0xff0000, Std.int(p.x), Std.int(p.y));
    actors.push(splash.activate(this, ground));
  }
}