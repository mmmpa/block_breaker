package view.common;
import view.common.Button.ButtonOption;
import starling.filters.BlurFilter;
import config.Def;
import db.Palette;
import model.common.ButtonProp;

using addition.Support;

class PresetButton {
  public static function normal(option:ButtonOption):Button {
    var prop:ButtonProp = option.prop.or(new ButtonProp());
    prop.bg = Palette.white;
    prop.effect = Palette.whiteGray;
    option.prop = prop;

    return new Button(option);
  }

  public static function forOk(option:ButtonOption):Button {
    var prop:ButtonProp = option.prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.blue;
    prop.effect = Palette.blueD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);
    option.prop = prop;

    return new Button(option);
  }

  public static function forSubmit(option:ButtonOption):Button {
    var prop:ButtonProp = option.prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.blueGreen;
    prop.effect = Palette.blueGreenD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);
    option.prop = prop;

    return new Button(option);
  }

  public static function forCansel(option:ButtonOption):Button {
    var prop:ButtonProp = option.prop.or(new ButtonProp());
    prop.color = Palette.white;
    prop.bg = Palette.red;
    prop.effect = Palette.redD;
    prop.filter = BlurFilter.createDropShadow(4, Math.PI / 180 * 90, Def.uiShadow, 0.5);
    option.prop = prop;

    return new Button(option);
  }
}
