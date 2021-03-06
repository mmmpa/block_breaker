package views.common;
import starling.events.Event;
import starling.filters.BlurFilter;
import configs.Configuration;
import assets.Se;
import models.common.ActorProp.ActorHorizontal;
import models.common.ButtonProp;
import contexts.BaseContext;
import configs.Def;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;

using additions.Support;

typedef ButtonOption = {
  var text:String;
  @:optional var prop:ButtonProp;
  @:optional var callback:Dynamic;
  @:optional var hoverCallback:Dynamic;
  @:optional var outCallback:Dynamic;
  @:optional var holdCallback:Dynamic;
}

class Button extends PartsActor {
  private var listener:ButtonListener;
  private var bg:Quad;
  private var hover:Quad;
  private var effect:Quad;
  private var label:Label;

  public var text:String;
  public var prop:ButtonProp;
  public var callback:Dynamic;
  public var hoverCallback:Dynamic;
  public var outCallback:Dynamic;
  public var holdCallback:Dynamic;

  public function new(option:ButtonOption = null) {
    super();
    this.deploy(option);

    this.label = new Label(text, Def.fontSizeNormal, prop.color, prop.char);
    this.bg = new Quad(1, 1, prop.bg);
    this.hover = new Quad(1, 1, prop.effect);
    this.effect = new Quad(1, 1, prop.effect);
    this.listener = new ButtonListener(1, 1);

    bg.filter = prop.filter;
    effect.alpha = 0;
    hover.alpha = 0.5;
    hover.visible = false;

    listener.down = function() {
      startHold();
    }

    listener.release = function() {
      endHold();
    }

    listener.click = function() {
      callback();
      if (Configuration.soundEnabled) {Se.hit.play(); }
    }

    listener.hover = function() {
      if (hoverCallback != null) {hoverCallback();}
      hover.visible = true;
    }

    listener.out = function() {
      if (outCallback != null) {outCallback();}
      hover.visible = false;
    }

    if (holdCallback != null) {
      listener.long = function() {
        endHold();
        holdCallback();
      }
    }


    addChild(bg);
    addChild(hover);
    addChild(effect);
    addChild(label);
    addChild(listener);

    initialize();
  }

  private function startHold() {
    Def.stage.addEventListener(Event.ENTER_FRAME, hold);
  }

  private function endHold() {
    Def.stage.removeEventListener(Event.ENTER_FRAME, hold);
    effect.alpha = 0;
  }

  private function hold(e:Event) {
    effect.alpha = listener.holdingRate;
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

    listener.width = hover.width = effect.width = bg.width;
    listener.height = hover.height = effect.height = bg.height;
    //flatten();
  }

  override public function deactivate() {
    Def.stage.removeEventListener(Event.ENTER_FRAME, hold);
    listener.deactivate();
    label.deactivate();
    super.deactivate();
  }

  override public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    parent.addChild(this);
  }
}
