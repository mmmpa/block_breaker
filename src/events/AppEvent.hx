package events;
import configs.Def;
import flash.events.Event;
class AppEvent extends Event {
  public function new() {
    super('started', false, false);
  }

  public function def(){
    return Def;
  }
}
