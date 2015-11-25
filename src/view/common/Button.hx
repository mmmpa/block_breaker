package view.common;
import config.Configuration;
import asset.Se;
import model.common.ActorProp.ActorHorizontal;
import model.common.ButtonProp;
import context.BaseContext;
import db.Palette;
import config.Def;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;

using addition.NullOr;

class Button extends PartsActor {
  private var listener:ButtonListener;
  private var bg:Quad;
  private var effect:Quad;
  private var label:Label;
  private var prop:ButtonProp;

  private var callback:Dynamic;
  //private var Map<Dynamic, CallbackList>;

  public static function normal(text:String, ?prop:ButtonProp, callback:Dynamic):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.bg = Palette.white;
    prop.effect = Palette.whiteGray;

    return new Button(text, prop, callback);
  }

  public function new(text:String, ?prop:ButtonProp, callback:Dynamic) {
    super();
    this.prop = prop;

    this.label = new Label(text, Def.fontSizeNormal, prop.faChar);
    this.bg = new Quad(1, 1, prop.bg);
    this.effect = new Quad(1, 1, prop.effect);
    this.listener = new ButtonListener(1, 1);

    listener.click = function() {
      callback();
      if (Configuration.soundEnabled) {Se.broken.play(); }
    }
    addChild(bg);
    addChild(label);
    addChild(listener);

    initialize();
  }

  public function resize(w:Float, h:Float):Button {
    if (w != 0) {
      prop.w = Std.int(w);
    }

    if (h != 0) {
      prop.h = Std.int(h);
    }

    initialize();

    return this;
  }

  public function initialize() {
    if (prop.w != 0) {
      bg.width = prop.w;
    } else {
      bg.width = Std.int(label.width) + (prop.padSide << 1);
    }

    if (prop.h != 0) {
      bg.height = prop.h;
    } else {
      bg.height = Std.int(label.height) + (prop.padTop << 1);
    }

    switch(prop.horizontal){
      case ActorHorizontal.Left:
        label.x = prop.padSide;
        label.y = prop.padTop;
      case ActorHorizontal.Right:
      case ActorHorizontal.Center:
        label.x = Std.int(bg.width - label.width) >> 1;
        label.y = Std.int(bg.height - label.height) >> 1;
    }

    listener.width = bg.width;
    listener.height = bg.height;
    flatten();
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
