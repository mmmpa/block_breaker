package db;
import flash.net.SharedObject;
class ConfigStore {
  static public var so:SharedObject = (function(){
    return SharedObject.getLocal("bb_configuration");
  })();

  static public var status(get, set):Bool;
  static public var sound(get, set):Bool;

  static public function get_status():Bool {
    return so.data.status;
  }

  static public function set_status(value:Bool):Bool {
    return so.data.status = value;
  }

  static public function get_sound():Bool {
    return so.data.sound;
  }

  static public function set_sound(value:Bool):Bool {
    return so.data.sound = value;
  }
}
