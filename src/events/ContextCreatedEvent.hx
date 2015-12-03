package events;
import starling.events.Event;
import contexts.BaseContext;
class ContextCreatedEvent extends Event {
  static public var CREATED:String = 'context created';
  public var context:BaseContext;

  public function new(context:BaseContext) {
    this.context = context;
    super(CREATED, false);
  }

  public function forMe(me:BaseContext):Bool{
    return this.context == me;
  }
}
