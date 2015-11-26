package view.blockbreaker;
import view.common.Button;
import asset.Fa;
import model.common.ButtonProp;
import view.common.PresetButton;
import config.Def;
import db.Palette;
import starling.display.Quad;
import view.common.PartsActor;

using addition.Support;

class GameOverWindow extends PartsActor {
  public var bg:Quad = new Quad(1, 1, Palette.white);
  public var gameover:GameOver = new GameOver();
  public var retry:Button;

  public function new(retryCallback:Dynamic) {
    super();
    bg.filter = Def.uiDs;
    bg.shape(Def.innerWidth, Def.innerMinHeight);

    retry = PresetButton.forSubmit('retry', ButtonProp.fa(Fa.char.refresh), function() {
      retryCallback();
    });

    addChild(bg);
    addChild(gameover);
    addChild(retry);

    gameover.center(bg);
    gameover.middle(bg, -retry.height / 2);
    retry.center(bg);
    retry.bottom(bg, -Def.paddingTop);
  }
}
