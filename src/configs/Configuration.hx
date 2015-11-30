package configs;
import dbs.ConfigStore;
import starling.utils.VAlign;
import starling.utils.HAlign;
import starling.core.Starling;
class Configuration {
  public static var soundEnabled:Bool = false;
  public static var statusEnabled:Bool = false;

  public static function initialize() {
    statusEnabled = ConfigStore.status;
    soundEnabled = ConfigStore.sound;
    apply();
  }

  public static function save() {
    ConfigStore.status = statusEnabled;
    ConfigStore.sound = soundEnabled;
    apply();
  }

  public static function apply() {
    if (statusEnabled) {
      Starling.current.showStats = true;
      Starling.current.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);
    } else {
      Starling.current.showStats = false;
    }
  }
}
