package view;
import view.app.BlockText;
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

using addition.Support;

class Notification extends BaseActor {
  public var bg:Quad = new Quad(1, 1, Palette.white);
  public var ds:BlurFilter = Def.uiDs;
  public var listener:ButtonListener = new ButtonListener(1, 1, 0);

  public var strictWidth = Def.innerWidth;
  public var minHeight = Def.innerMinHeight;
  public var maxHeight = Def.innerHeight;
  private var tfWidth:Int = Def.innerWidth - Def.paddingSide * 2;

  public var messageTf:TextField;
  public var titleTf:TextField;
  public var underline:Quad;

  public function new(title:String, message:String, callback:Dynamic) {
    super();
    bg.shape(strictWidth, minHeight);

    bg.filter = ds;
    addChild(bg);
    addChild(listener);
    listener.click = callback;

    if (title.length != 0) {
      titleTf = new BlockText(tfWidth, 1, title);
      titleTf.posit(Def.paddingSide, Def.paddingTop);
      addChild(titleTf);
      underline = new Quad(strictWidth, 1, Def.uiLine);
      underline.y = titleTf.bounds.bottom + Def.paddingTop;
      addChild(underline);
    }

    messageTf = new BlockText(tfWidth, 1, message);
    messageTf.x = Def.paddingSide;
    addChild(messageTf);

    if (titleTf == null) {
      messageTf.y = Def.paddingTop;
    } else {
      messageTf.y = titleTf.bounds.bottom + Def.paddingTop * 2;
    }

    var need:Float = messageTf.bounds.bottom + Def.paddingTop;
    if (maxHeight < need) {
      bg.height = maxHeight;

      var container:ScrollContainer = new ScrollContainer();
      container.shape(strictWidth, maxHeight);
      addChild(container);

      if (titleTf != null) {
        container.addChild(titleTf);
        container.addChild(underline);
      }
      container.addChild(messageTf);
    } else if (need > minHeight) {
      bg.height = need;
    } else {
      messageTf.autoSize = TextFieldAutoSize.NONE;
      messageTf.height = minHeight - messageTf.y - Def.paddingTop;
    }

    listener.fit(bg);
  }
}
