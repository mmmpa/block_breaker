package views.common;
import flash.display.StageQuality;
import configs.Def;
import assets.Fa;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

class FaIcon extends PartsActor {
  private var baseSize:Int;
  private var scaleSize:Int = 1;
  private var icon:TextField;

  public function new(char:String, size:Int, ?color:Int) {
    super();
    Def.rawStage.quality = StageQuality.BEST;
    this.icon = new TextField(1, 1, char);
    this.baseSize = size;
    icon.fontName = Fa.name;
    icon.color = color;
    this.addChild(icon);
    draw();
    this.flatten();
    Def.rawStage.quality = StageQuality.LOW;
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
