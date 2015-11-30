package assets;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.media.Sound;
class Se extends Sound {
  static public var hard:Se = loadAsset('hard');
  static public var hit:Se = loadAsset('hit');
  static public var broken:Se = loadAsset('break');

  static public function loadAsset(name:String):Se {
    var data = haxe.Resource.getBytes(name);
    var sound = new Se();
    sound.loadCompressedDataFromByteArray(data.getData(), data.length);
    sound.play(0).stop();
    return sound;
  }

  override public function play(start:Float = 0, repeat:Int = 0, transform:SoundTransform = null):SoundChannel {
    return super.play(40);
  }
}
