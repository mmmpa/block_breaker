package events;
import routers.SceneChangeData;
import starling.events.Event;
class SceneChangeEvent extends Event {
  static public var GO:String = 'scene:change';
  public var routeData:SceneChangeData;

  public function new(routeData:SceneChangeData) {
    this.routeData = routeData;
    super(GO, false);
  }
}
