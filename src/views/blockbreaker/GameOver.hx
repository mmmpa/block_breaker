package views.blockbreaker;
import dbs.Palette;
import assets.Fa;
import configs.Def;
import views.common.Label;
class GameOver extends Label{
  public function new() {
    super('game over', Def.fontSizeBig, Palette.white);
  }
}
