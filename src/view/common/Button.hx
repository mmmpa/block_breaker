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
import config.Def;
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
  private var label:Label;
  private var prop:ButtonProp;

  private var callback:Dynamic;
  //private var Map<Dynamic, CallbackList>;

  public static function normal(callback:Dynamic, ?prop:ButtonProp, ?text:String, ?faChar:String):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.faChar = faChar.or('');
    prop.color = Palette.white;
    prop.bg = Palette.gray;
    prop.effect = Palette.grayD;

    return new Button(
    callback,
    prop,
    text.or('Button'),
    faChar.or('')
    );
  }

  public function new(callback:Dynamic, prop:ButtonProp, text:String, ?faChar:String) {
    super();
    this.prop = prop;

    this.label = new Label(text, 20, faChar);
    this.bg = new Quad(1, 1, prop.color);
    this.effect = new Quad(1, 1, prop.effect);
    this.listener = new ButtonListener(1, 1);

    listener.click = callback;
    addChild(bg);
    addChild(label);
    addChild(listener);

    initialize();
  }

  public function resize(w:Float, h:Float):Button {
    if (w != 0) {
      prop.width = Std.int(w);
    }

    if (h != 0) {
      prop.height = Std.int(h);
    }

    initialize();

    return this;
  }

  public function initialize() {
    if (prop.width != 0) {
      bg.width = prop.width;
    } else {
      bg.width = Std.int(label.width) + (prop.paddingSide << 1);
    }

    if (prop.height != 0) {
      bg.height = prop.height;
    } else {
      bg.height = Std.int(label.height) + (prop.paddingTop << 1);
    }

    switch(prop.align){
      case ButtonAlign.Left:
        label.x = prop.paddingSide;
        label.y = prop.paddingTop;
      case ButtonAlign.Right:
      case ButtonAlign.Center:
        label.x = Std.int(bg.width - label.width) >> 1;
        label.y = Std.int(bg.height - label.height) >> 1;
    }


    listener.width = bg.width;
    listener.height = bg.height;
  }

  override public function deactivate() {
    listener.deactivate();
    label.deactivate();
    super.deactivate();
  }

  override public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
  }
}
