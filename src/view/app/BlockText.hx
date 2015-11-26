package view.app;
import starling.text.TextFieldAutoSize;
import config.Def;
import asset.BlockFont;
import starling.utils.VAlign;
import starling.utils.HAlign;
import starling.text.TextField;

class BlockText extends TextField {
  public function new(w:Float = 1, h:Float = 1, text = '') {
    super(Std.int(w), Std.int(h), text);
    hAlign = HAlign.LEFT;
    vAlign = VAlign.CENTER;
    autoSize = TextFieldAutoSize.VERTICAL;
    fontName = BlockFont.name;
    fontSize = Def.fontSizeNormal;
  }
}
