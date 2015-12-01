package views.common;
import starling.display.Image;
import flash.display.Bitmap;
import flash.display.StageQuality;
import configs.Def;
import assets.Fa;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.textures.Texture;

using additions.Creator;

class FaIcon extends PartsActor {
  private var baseSize:Int;
  private var scaleSize:Int = 1;
  private var icon:TextField;
  private var max:Float;
  private var size:Int;
  private var image:Image;

  public function new(Char:Class<Dynamic>, size:Int, ?color:Int) {
    super();
    this.size = size;
    var bitmap:Bitmap = Type.createInstance(Type.resolveClass(Type.getClassName(Char)), []);
    max = bitmap.width > bitmap.height ? bitmap.width : bitmap.height;
    image = new Image(Texture.fromBitmap(bitmap));
    addChild(image);
    draw();
  }

  public function draw():FaIcon{
    var rate:Float = size / max;
    image.scaleX = image.scaleY = rate;
    initializeArea(image.width, image.height);
    image.pivotX = image.width / 2;
    image.pivotY = image.height / 2;
    return this;
  }

  override public function deactivate(){
    icon.dispose();
    super.deactivate();
  }

  public function scale(n:Int):FaIcon {
    this.scaleSize = n;
    draw();
    return this;
  }

  public function rotate(n:Float):FaIcon {
    icon.rotation = degreeToRadian(n);
    return this;
  }

  private function degreeToRadian(n:Float) {
    return n * Math.PI / 180;
  }
}

