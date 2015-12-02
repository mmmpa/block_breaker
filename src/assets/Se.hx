package assets;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
class Se {
  static public var hard:Se;
  static public var hit:Sound;
  static public var broken:Sound;

  public function new() {

  }

  static public function initialize() {
    hit = new HitSe();
    broken = new BreakSe();
  }

  public function play(start:Float = 0, repeat:Int = 0, transform:SoundTransform = null):SoundChannel {
    return null;
  }
}
