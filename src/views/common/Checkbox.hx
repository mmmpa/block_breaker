package views.common;
import configs.Configuration;
import assets.Se;
import dbs.Palette;
import models.common.ActorProp.ActorHorizontal;
import models.common.CheckboxProp;
import configs.Def;

using additions.Support;

class Checkbox extends PartsActor {
  private var listener:ButtonListener;

  public var text:String;
  public var checked:Bool;
  public var prop:CheckboxProp;
  public var callback:Dynamic;

  private var label:Label;
  private var checkedIcon:FaIcon;
  private var uncheckedIcon:FaIcon;

  public static function normal(option:{text:String, callback:Dynamic, ?checked:Bool, ?prop:CheckboxProp}) {
    if (option.prop == null) {
      option.prop = new CheckboxProp();
    }
    option.prop.checkedColor = Palette.blueD;
    option.prop.uncheckedColor = Palette.grayD;

    return new Checkbox(option);
  }

  public function new(option:{text:String, callback:Dynamic, ?checked:Bool, ?prop:CheckboxProp}) {
    super();
    this.deploy(option, {
      checked: false,
      prop: new CheckboxProp()
    });

    this.label = new Label(text, Def.fontSizeNormal);
    this.listener = new ButtonListener(1, 1);
    this.checkedIcon = new FaIcon(Check31, Def.fontSizeNormal, prop.checkedColor);
    this.uncheckedIcon = new FaIcon(Check29, Def.fontSizeNormal, prop.uncheckedColor);
    listener.click = toggle;

    addChildren([
      checkedIcon,
      uncheckedIcon,
      label,
      listener
    ]);

    reposit();
    drawCheckmark();
  }

  public function toggle() {
    this.checked = !checked;
    drawCheckmark();
    callback(this);
    if (Configuration.soundEnabled) {Se.broken.play(); }
  }

  public function drawCheckmark() {
    checkedIcon.visible = checked;
    uncheckedIcon.visible = !checked;
  }

  public function resize(w:Float, h:Float):Checkbox {
    if (w != 0) prop.w = Std.int(w);
    if (h != 0) prop.h = Std.int(h);

    reposit();

    return this;
  }

  public function reposit() {
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
