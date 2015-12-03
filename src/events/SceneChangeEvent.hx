package events;
import routers.RouteData;
import starling.events.Event;
class SceneChangeEvent extends Event {
  static public var GO:String = 'scene:change';
  public var routeData:RouteData;

  public function new(routeData:RouteData) {
    this.routeData = routeData;
    super(GO, false);
  }
}
