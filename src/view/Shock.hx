package view;
import starling.display.Image;
import starling.textures.Texture;
import model.ShockData;
import flash.display.BitmapData;

class Shock extends Image {
  public static var _tex:Texture;

  public var data:ShockData;

  static public function tex():Texture {
    if (_tex != null) {
      return _tex;
    }
    var sp:flash.display.Sprite = new flash.display.Sprite();
    var g:flash.display.Graphics = sp.graphics;
    g.beginFill(0xFF0000);
    g.drawCircle(50, 50, 50);
    g.endFill();
    var bd:BitmapData = new BitmapData(100, 100, true, 0);
    bd.draw(sp);

    return _tex = Texture.fromBitmapData(bd);
  }

  public function new(data:ShockData) {
    super(tex());
    this.data = data;
    reposit();
  }

  public function reposit() {
    this.x = data.x - data.size;
    this.y = data.y - data.size;
    this.width = data.size * 2;
    this.height = data.size * 2;
  }
}
