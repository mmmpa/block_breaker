package events;
import starling.events.Event;
class SideMenuEvent extends Event {
  static public var OPENED:String = 'sidemenu:opened';
  static public var CLOSED:String = 'sidemenu:closed';

  static public function newOpened():SideMenuEvent {
    return new SideMenuEvent(OPENED);
  }

  static public function newClosed():SideMenuEvent {
    return new SideMenuEvent(CLOSED);
  }
}
