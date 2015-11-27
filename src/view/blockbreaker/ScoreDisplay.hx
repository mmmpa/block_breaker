package view.blockbreaker;
import config.Def;
import view.app.BlockText;
class ScoreDisplay extends BlockText {
  @:isVar public var score(default, set):Int;

  public function new() {
    super(Def.area.w - Def.paddingSide * 2, 100);
    this.text = ' ';
  }

  public function set_score(value:Int):Int {
    if(this.score == value && value != 0){
      return value;
    }
    this.text = 'score:' + Std.string(value);
    return this.score = value;
  }
}
