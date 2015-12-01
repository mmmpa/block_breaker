package views.blockbreaker;
import views.common.Button;
import assets.Fa;
import models.common.ButtonProp;
import views.common.PresetButton;
import configs.Def;
import dbs.Palette;
import starling.display.Quad;
import views.common.PartsActor;

using additions.Support;

typedef GameOverWindowOption = {
  var retryCallback:Dynamic;
  var backCallback:Dynamic;
}

class GameOverWindow extends PartsActor {
  public var bg:Quad = new Quad(1, 1, Palette.black);
  public var gameover:GameOver = new GameOver();

  public var retryCallback:Dynamic;
  public var backCallback:Dynamic;

  public function new(option:GameOverWindowOption) {
    super();
    this.deploy(option);

    bg.filter = Def.uiDs;
    bg.shape(Def.area.w, Def.innerMinHeight);

    var retry:Button = PresetButton.forOk({
      text: 'retry',
      prop: new ButtonProp({char: Refresh36}),
      callback: function() {
        retryCallback();
        removeFromParent();
      }
    });

    var back:Button = PresetButton.forSubmit({
      text: 'back to stage finder',
      prop: new ButtonProp({char: Chevron24}),
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
