package events;
import configs.OnAir;
import configs.Def;
import flash.events.Event;
class AppEvent extends Event {
  public var onAir:Class<OnAir> = OnAir;

  public function new() {
    super('started', false, false);
  }
}
