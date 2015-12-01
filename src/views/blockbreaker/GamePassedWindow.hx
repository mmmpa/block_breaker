package views.blockbreaker;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import views.app.BlockText;
import views.common.Button;
import assets.Fa;
import models.common.ButtonProp;
import views.common.PresetButton;
import configs.Def;
import dbs.Palette;
import starling.display.Quad;
import views.common.PartsActor;

using additions.Support;

typedef GamePassedWindowOption = {
  var score:Int;
  var bestScore:Int;
  var recordBroken:Bool;
  var retryCallback:Dynamic;
  var backCallback:Dynamic;
}

class GamePassedWindow extends PartsActor {
  public var bg:Quad = new Quad(1, 1, Palette.white);
  public var score:Int;
  public var bestScore:Int;
  public var recordBroken:Bool;
  public var retryCallback:Dynamic;
  public var backCallback:Dynamic;

  public function new(option:GamePassedWindowOption) {
    super();
    this.deploy(option);

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

    bg.filter = Def.uiDs;
    bg.shape(Def.area.w, Def.innerMinHeight);

    var clearMessage:String = recordBroken ? 'break a record!!' : 'clear!' ;
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
    back.center(bg);
    back.under(retry, Def.paddingTop);

    bg.height = back.bottomLine(Def.paddingTop);

    addChild(bg);
    addChild(clear);
    addChild(score);
    addChild(bestScore);
    addChild(retry);
    addChild(back);
  }
}
