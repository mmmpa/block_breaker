package initializer;

import flash.system.Capabilities;
import addition.Sizing;

class Scale {
  static public function initialize() {
    var target_dpi:Float = Capabilities.screenDPI;
    var base_dpi:Float = 72;
    Sizing.scale = target_dpi / base_dpi;
  }
}
