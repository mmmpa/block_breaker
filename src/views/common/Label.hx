package views.common;
import configs.Def;
import assets.BlockFont;
import starling.text.TextFieldAutoSize;
import starling.text.TextField;

class Label extends PartsActor {
  private var tf:TextField;
  private var icon:FaIcon;

  public function new(text:String, size:Int = 0, ?color:Int = 0, ?char:Class<Dynamic>) {
    super();

    this.tf = new TextField(1, 1, text);
    tf.color = color;
    tf.fontSize = size == 0 ? Def.fontSizeNormal : size;
    tf.fontName = BlockFont.name;
    tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    this.addChild(tf);

    if (char != null) {
      this.icon = new FaIcon(char, Std.int(size * 0.8), color);
      this.addChild(icon);
    }

    posit();
    initializeArea();
    flatten();
  }

  override public function deactivate() {
    if (icon != null) {
      icon.deactivate();
    }
    tf.dispose();
    super.deactivate();
  }

  public function posit() {
    if (icon != null) {
      tf.x = Std.int(tf.height);
      if (tf.height > icon.height) {
        icon.y = Std.int((tf.height - icon.height) / 2);
      } else {
        tf.y = Std.int((icon.height - tf.height) / 2);
      }
    }
  }
}

