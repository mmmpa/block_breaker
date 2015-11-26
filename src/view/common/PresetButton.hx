package view.common;
import starling.filters.BlurFilter;
import config.Def;
import db.Palette;
import model.common.ButtonProp;

using addition.NullOr;

class PresetButton {
  public static function normal(text:String, ?prop:ButtonProp, callback:Dynamic):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.bg = Palette.white;
    prop.effect = Palette.whiteGray;

    return new Button(text, prop, callback);
  }

  public static function forOk(text:String, ?prop:ButtonProp, callback:Dynamic):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.blue;
    prop.effect = Palette.blueD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);

    return new Button(text, prop, callback);
  }

  public static function forSubmit(text:String, ?prop:ButtonProp, callback:Dynamic):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.blueGreen;
    prop.effect = Palette.blueGreenD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);

    return new Button(text, prop, callback);
  }

  public static function forCansel(text:String, ?prop:ButtonProp, callback:Dynamic):Button {
    var prop:ButtonProp = prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.red;
    prop.effect = Palette.redD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);

    return new Button(text, prop, callback);
  }
}
