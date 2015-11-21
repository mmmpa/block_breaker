package view.common;
import starling.text.TextFieldAutoSize;
import starling.text.TextField;

class Label extends PartsActor {
  private var tf:TextField;
  private var icon:FaIcon;

  public function new(text:String, size:Int = 0, ?iconChar:String) {
    super();

    this.tf = new TextField(1, 1, text);
    tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    this.addChild(tf);

    if (iconChar != null || iconChar != '') {
      this.icon = new FaIcon(iconChar, Std.int(size * 0.7));
      this.addChild(icon);
    }

    posit();
    initializeArea();
  }

  public function posit() {
    if(icon != null){
      tf.x = icon.width;
      if(tf.height > icon.height){
        icon.y = (tf.height - icon.height) / 2;
      }else{
        tf.y = (icon.height - tf.height) / 2;
      }
    }
  }
}

