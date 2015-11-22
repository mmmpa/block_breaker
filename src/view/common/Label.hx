package view.common;
import addition.Def;
import asset.BlockFont;
import starling.text.TextFieldAutoSize;
import starling.text.TextField;

class Label extends PartsActor {
  private var tf:TextField;
  private var icon:FaIcon;

  public function new(text:String, size:Int = 0, ?iconChar:String) {
    super();

    this.tf = new TextField(1, 1, text);
    tf.fontSize = size == 0 ? Def.fontSizeNormal : size;
    tf.fontName = BlockFont.name;
    tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    this.addChild(tf);

    if (iconChar != null || iconChar != '') {
      this.icon = new FaIcon(iconChar, Std.int(size * 0.7));
      this.addChild(icon);
    }

    posit();
    initializeArea();
  }

  override public function deactivate(){
    if(icon != null){
      icon.deactivate();
    }
    tf.dispose();
    super.deactivate();
  }

  public function posit() {
    if(icon != null){
      tf.x = Std.int(tf.height);

      if(tf.height > icon.height){
        icon.y = Std.int((tf.height - icon.height) / 2);
      }else{
        tf.y = Std.int((icon.height - tf.height) / 2);
      }
    }
  }
}

