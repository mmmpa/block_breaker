package view.common;
import config.Configuration;
import asset.Se;
import asset.Fa;
import db.Palette;
import model.common.ActorProp.ActorHorizontal;
import model.common.CheckboxProp;
import config.Def;

class Checkbox extends PartsActor {
  public var prop:CheckboxProp;
  private var listener:ButtonListener;

  public var checked:Bool;
  private var label:Label;
  private var checkedIcon:FaIcon;
  private var uncheckedIcon:FaIcon;
  private var callback:Dynamic;

  public static function normal(text:String, checked:Bool, position:ActorHorizontal, callback:Dynamic) {
    return new Checkbox(text, checked, new CheckboxProp(Palette.blueD, Palette.grayD, position), callback);
  }

  public function new(text:String, checked:Bool, prop:CheckboxProp, callback:Dynamic) {
    super();
    this.prop = prop;
    this.checked = checked;
    this.label = new Label(text, Def.fontSizeNormal);
    this.listener = new ButtonListener(1, 1);
    this.checkedIcon = new FaIcon(Fa.char.checkSquare, Def.fontSizeNormal, prop.checkedColor);
    this.uncheckedIcon = new FaIcon(Fa.char.squareO, Def.fontSizeNormal, prop.uncheckedColor);
    this.callback = callback;
    listener.click = toggle;

    addChild(checkedIcon);
    addChild(uncheckedIcon);
    addChild(label);
    addChild(listener);

    initialize();
    draw();
  }

  public function toggle() {
    this.checked = !checked;
    draw();
    callback(this);
    if (Configuration.soundEnabled) {Se.broken.play(); }
  }

  public function draw() {
    checkedIcon.visible = checked;
    uncheckedIcon.visible = !checked;
  }

  public function resize(w:Float, h:Float):Checkbox {
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
      listener.width = prop.w;
    } else {
      listener.width = Std.int(label.width) + (Def.fontSizeNormal >> 1) + Std.int(checkedIcon.width) + (prop.padSide << 1);
    }

    if (prop.h != 0) {
      listener.height = prop.h;
    } else {
      listener.height = Std.int(label.height) + (prop.padTop << 1);
    }

    var offset:Int = Std.int(Math.abs(uncheckedIcon.height - label.height));
    if (uncheckedIcon.height > label.height) {
      checkedIcon.y = uncheckedIcon.y = prop.padTop;
      label.y = prop.padTop + offset;
    } else {
      label.y = prop.padTop;
      checkedIcon.y = uncheckedIcon.y = prop.padTop + offset;
    }


    switch(prop.position){
      case ActorHorizontal.Left:
        checkedIcon.x = uncheckedIcon.x = prop.padSide;
        label.x = listener.width - (label.width + prop.padSide);
      case ActorHorizontal.Right:
        label.x = prop.padSide;
        checkedIcon.x = uncheckedIcon.x = listener.width - (checkedIcon.width + prop.padSide);
      case ActorHorizontal.Center:
        checkedIcon.x = uncheckedIcon.x = prop.padSide;
        label.x = listener.width - (label.width + prop.padSide);
    }
  }
}
