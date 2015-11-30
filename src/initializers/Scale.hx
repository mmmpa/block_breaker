package initializers;

import flash.system.Capabilities;
import configs.Sizing;

class Scale {
  static public function initialize() {
    var target_dpi:Float = Capabilities.screenDPI;
    var base_dpi:Float = 72;
    trace(target_dpi);
    Sizing.dpi = Capabilities.screenDPI;
    if(target_dpi != base_dpi){
      Sizing.dpmm = Capabilities.screenDPI / 25.4;
    }else{
      Sizing.dpmm = Capabilities.screenDPI / 10.7;
    }

    Sizing.scale = target_dpi / base_dpi;
  }
}
