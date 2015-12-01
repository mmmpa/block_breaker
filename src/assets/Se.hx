package assets;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.media.Sound;
class Se {
  static public var hard:Se;
  static public var hit:Se;
  static public var broken;

  public function new() {

  }

  static public function initialize() {
    hard = new Se();
    hit = new Se();
    broken = new Se();
  }

  public function play(start:Float = 0, repeat:Int = 0, transform:SoundTransform = null):SoundChannel {
    return null;
  }
}
