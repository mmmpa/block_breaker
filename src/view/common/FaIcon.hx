package view.common;
import starling.display.Quad;
import starling.display.DisplayObjectContainer;
import context.BaseContext;
import asset.Fa;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

class FaIcon extends PartsActor {
  private var baseSize:Int;
  private var scaleSize:Int = 1;
  private var icon:TextField;

  public function new(char:String, size:Int) {
    super();
    this.icon = new TextField(1, 1, char);
    this.baseSize = size;
    icon.fontName = Fa.name;
    this.addChild(icon);
    draw();
  }

  public function draw():FaIcon{
    icon.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    icon.fontSize = baseSize * scaleSize;
    var max:Float = icon.width > icon.height ? icon.width: icon.height;
    initializeArea(max, max);
    icon.x = max / 2;
    icon.y = max / 2;
    icon.pivotX = icon.width / 2;
    icon.pivotY = icon.height / 2;
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
