package initializer;

import flash.system.Capabilities;
import config.Sizing;

class Scale {
  static public function initialize() {
    var target_dpi:Float = Capabilities.screenDPI;
    var base_dpi:Float = 72;
    Sizing.dpi = Capabilities.screenDPI;
    Sizing.dpmm = Capabilities.screenDPI / 25.4;

    Sizing.scale = target_dpi / base_dpi;
  }
}
