package view.blockbreaker;
import db.Palette;
import asset.Fa;
import config.Def;
import view.common.Label;
class GameOver extends Label{
  public function new() {
    super('game over', Def.fontSizeBig, Palette.white);
  }
}
