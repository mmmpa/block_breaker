package view.blockbreaker;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import view.app.BlockText;
import view.common.Button;
import asset.Fa;
import model.common.ButtonProp;
import view.common.PresetButton;
import config.Def;
import db.Palette;
import starling.display.Quad;
import view.common.PartsActor;

using addition.Support;

class GamePassedWindow extends PartsActor {
  public var bg:Quad = new Quad(1, 1, Palette.white);
  public var retry:Button;

  public function new(score:Float, bestScore:Float, reacordBroken:Bool, retryCallback:Dynamic) {
    super();

    retry = PresetButton.forSubmit('retry', ButtonProp.fa(Fa.char.refresh), function() {
      retryCallback();
      removeFromParent();
    });

    bg.filter = Def.uiDs;
    bg.shape(Def.area.w, Def.innerMinHeight);

    var clearMessage:String = reacordBroken ? 'break a record!!' : 'clear!' ;
    var clear:BlockText = new BlockText(1, 1, clearMessage);
    var score:BlockText = new BlockText(1, 1, 'score:' + Std.string(score));
    var bestScore:BlockText = new BlockText(1, 1, 'best:' + Std.string(bestScore));

    clear.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    score.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    bestScore.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;

    clear.fontSize = Def.fontSizeBig;
    clear.hAlign = HAlign.CENTER;
    score.hAlign = HAlign.LEFT;
    bestScore.hAlign = HAlign.LEFT;

    var max:Float = score.width > bestScore.width ? score.width : bestScore.width;
    score.autoSize = TextFieldAutoSize.VERTICAL;
    bestScore.autoSize = TextFieldAutoSize.VERTICAL;
    score.width = bestScore.width = max;

    clear.center(bg);
    clear.y = Def.paddingTop;

    score.center(bg);
    bestScore.center(bg);
    score.under(clear, Def.paddingTop >> 1);
    bestScore.under(score, Def.paddingTop >> 1);

    retry.center(bg);
    retry.under(bestScore, Def.paddingTop);

    bg.height = retry.bottomLine(Def.paddingTop);

    addChild(bg);
    addChild(clear);
    addChild(score);
    addChild(bestScore);
    addChild(retry);

  }
}
