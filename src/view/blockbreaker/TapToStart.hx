package view.blockbreaker;
import asset.Fa;
import config.Def;
import view.common.Label;
class TapToStart extends Label{
  public function new() {
    super('tap to start', Def.fontSizeNormal, Fa.char.handOUp);
  }
}