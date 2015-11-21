package view.common;
import asset.Fa;
import model.common.ButtonProp;
import context.BaseContext;
import starling.text.TextFieldAutoSize;
import db.Palette;
import starling.events.TouchEvent;
import starling.events.Touch;
import flash.geom.Point;
import starling.events.TouchPhase;
import addition.Def;
import starling.display.DisplayObjectContainer;
import starling.text.TextField;
import flash.geom.Rectangle;
import starling.display.Quad;
import starling.display.Sprite;

using addition.NullOr;

class Button extends PartsActor {
  private var listener:ButtonListener;
  private var bg:Quad;
  private var effect:Quad;
  private var tf:TextField;
  private var icon:FaIcon;
  private var prop:ButtonProp;

  private var callback:Dynamic;
  //private var Map<Dynamic, CallbackList>;

  public static function normal(callback:Dynamic, ?prop:ButtonProp, ?text:String, ?faChar:String):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.faChar = faChar.or('');
    prop.color = Palette.gray;
    prop.effect = Palette.grayD;

    return new Button(
    callback,
    prop,
    text.or('Button')
    );
  }

  public function new(callback:Dynamic, prop:ButtonProp, text:String) {
    super();
    this.prop = prop;

    this.tf = new TextField(1, 1, text);
    this.bg = new Quad(1, 1, prop.color);
    this.effect = new Quad(1, 1, prop.effect);
    this.listener = new ButtonListener(1, 1);

    listener.click = callback;
    listener.out = function(){
      trace('out');
    };
    addChild(bg);
    addChild(tf);
    addChild(listener);

    initialize();
  }

  public function initialize() {
    tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    tf.x = prop.paddingSide;
    tf.y = prop.paddingTop;

    if (prop.width != 0) {
      bg.width = prop.width;
    } else {
      bg.width = Std.int(tf.width) + (prop.paddingSide << 1);
    }

    if (prop.height != 0) {
      bg.height = prop.height;
    } else {
      bg.height = Std.int(tf.height) + (prop.paddingTop << 1);
    }

    listener.width = bg.width;
    listener.height = bg.height;
  }

  override public function deactivateToo() {
    listener.deactivate();
  }

  override public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
  }
}
