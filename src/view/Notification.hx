package view;
import feathers.controls.ScrollContainer;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import starling.utils.VAlign;
import starling.utils.HAlign;
import asset.BlockFont;
import starling.text.TextFieldAutoSize;
import view.common.ButtonListener;
import starling.text.TextField;
import view.common.BaseActor;
import starling.filters.BlurFilter;
import config.Def;
import db.Palette;
import starling.display.Quad;

class Notification extends BaseActor {
  public var bg:Quad = new Quad(1, 1, Palette.white);
  public var ds:BlurFilter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);
  public var strictWidth = Std.int(Def.area.w / 1.618);
  public var minHeight = Std.int(Def.area.w / 1.1618 / 1.618);
  public var maxHeight = Std.int(Def.area.h - (Def.area.w - Def.area.w / 1.618));
  public var listener:ButtonListener = new ButtonListener(1, 1);

  public var messageTf:TextField;
  public var titleTf:TextField;
  public var underline:Quad;

  public function new(title:String, message:String, callback:Dynamic) {
    super();

    bg.width = strictWidth;
    bg.height = minHeight;
    bg.filter = ds;
    addChild(bg);

    if (title.length != 0) {
      titleTf = new TextField(strictWidth - 20, 1, title);
      titleTf.x = 10;
      titleTf.y = 5;
      titleTf.autoSize = TextFieldAutoSize.VERTICAL;
      titleTf.fontName = BlockFont.name;
      titleTf.fontSize = Def.fontSizeNormal;
      addChild(titleTf);
      underline = new Quad(strictWidth, 1, Def.uiLine);
      underline.y = titleTf.bounds.bottom + 5;
      addChild(underline);
    }

    messageTf = new TextField(strictWidth - 20, 1, message);
    messageTf.hAlign = HAlign.LEFT;
    messageTf.vAlign = VAlign.CENTER;
    messageTf.autoSize = TextFieldAutoSize.VERTICAL;
    messageTf.fontName = BlockFont.name;
    messageTf.fontSize = Def.fontSizeNormal;
    messageTf.x = 10;
    addChild(messageTf);

    if (titleTf == null) {
      messageTf.y = 5;
    } else {
      messageTf.y = titleTf.bounds.bottom + 11;
    }

    var need:Float = messageTf.bounds.bottom + 10;
    if (maxHeight < need) {
      var container:ScrollContainer = new ScrollContainer();
      container.width = strictWidth;
      container.height = maxHeight;
      bg.height = maxHeight;
      addChild(container);
      if (titleTf != null) {
        container.addChild(titleTf);
        container.addChild(underline);
      }
      container.addChild(messageTf);
    }else if(need > minHeight){
      bg.height = need;
    } else {
      messageTf.autoSize = TextFieldAutoSize.NONE;
      messageTf.height = minHeight - messageTf.y - 10;
    }
  }
}
