package view;
import starling.display.DisplayObject;
import flash.geom.Point;
import db.Palette;
import flash.display.SpreadMethod;
import flash.geom.Matrix;
import config.Def;
import flash.display.BitmapData;
import flash.display.GradientType;
import starling.textures.Texture;
import starling.display.Image;
class NormalBg extends Image {
  static public var tex:Texture;

  public function new() {
    if (tex == null) {
      tex = generateBg();
    }
    super(tex);
    //this.touchable = false;
  }

  override public function hitTest(localPoint:Point, forTouch:Bool = false):DisplayObject {
    //trace(this);
    return super.hitTest(localPoint, forTouch);
  }

  static public function generateBg():Texture {
    var sp:flash.display.Sprite = new flash.display.Sprite();
    var g:flash.display.Graphics = sp.graphics;
    var matrix:Matrix = new Matrix();
    matrix.createGradientBox(Def.area.w, Def.area.h, Math.PI / 2, 0, 0);
    g.beginGradientFill(GradientType.LINEAR,
    [Palette.whiteLightGray, Palette.white, Palette.white, Palette.whiteLightGray],
    [1, 1, 1, 1],
    [0, 100, 155, 255],
    matrix,
    SpreadMethod.PAD);
    g.drawRect(0, 0, Def.area.w, Def.area.h);
    var bd:BitmapData = new BitmapData(Def.area.w, Def.area.h, false, 0);
    bd.draw(sp);

    return Texture.fromBitmapData(bd);
  }
}

