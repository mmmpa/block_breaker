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
  public var bg:Quad = new Quad(1, 1, Palette.black);
  public var gameover:GameOver = new GameOver();
  public var retry:Button;
  public var back:Button;

  public function new(retryCallback:Dynamic, backCallback:Dynamic) {
    super();
    bg.filter = Def.uiDs;
    bg.shape(Def.area.w, Def.innerMinHeight);

    retry = PresetButton.forOk({
      text: 'retry',
      prop: new ButtonProp({faChar: Fa.char.refresh}),
      callback: function() {
        retryCallback();
        removeFromParent();
      }
    });

    back = PresetButton.forSubmit({
      text: 'back to stage finder',
      prop: new ButtonProp({faChar: Fa.char.arrowCircleLeft}),
      callback: function() {
        backCallback();
        removeFromParent();
      }
    });

    addChild(bg);
    addChild(gameover);
    addChild(retry);
    addChild(back);

    gameover.center(bg);
    gameover.y = Def.paddingTop;
    retry.center(bg);
    retry.under(gameover, Def.paddingTop);
    back.center(bg);
    back.under(retry, Def.paddingTop);

    bg.shape(Def.area.w, back.bottomLine(Def.paddingTop));
  }
}
