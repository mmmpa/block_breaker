package context.blockbreaker;
import view.blockbreaker.GamePassedWindow;
import db.RecordStore;
import view.blockbreaker.ScoreDisplay;
import view.blockbreaker.GameOverWindow;
import view.blockbreaker.BlockTable;
import model.blockbreaker.BlockGrid;
import model.blockbreaker.ImageBlockGrid;
import model.blockbreaker.ImageBlockBreakerProp;
import config.Configuration;
import asset.Se;
import model.blockbreaker.BlockBreakerState;
import view.blockbreaker.TapToStart;
import view.NormalBg;
import model.blockbreaker.BlockBreakerPlayingState;
import model.blockbreaker.BallData;
import model.blockbreaker.BlockBreaker;
import model.blockbreaker.ShockData;
import view.blockbreaker.Shock;
import view.blockbreaker.Ball;
import starling.events.TouchPhase;
import starling.display.Quad;
import config.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;
using addition.Support;

class ImageBlockBreakerContext extends BaseContext {

  private var game:BlockBreaker;
  private var table:BlockTable;
  private var listener:Quad;
  private var tapToStart:TapToStart = new TapToStart();
  private var gameOver:GameOverWindow;
  private var scoreDisplay:ScoreDisplay = new ScoreDisplay();
  private var gamePassed:GamePassedWindow;
  private var retry:Dynamic;

  public function new(props:RouterProp, insertProps:ImageBlockBreakerProp) {
    super(props);
    ground.y = Def.area.y;
    listener = new NormalBg();

    var start:Dynamic = function() {
      new ImageBlockGrid(insertProps.path, function(grid:BlockGrid) {
        game = new BlockBreaker(insertProps.id, grid);
        table = new BlockTable(grid);
        beOnStage(table, true);
        scoreDisplay.score = game.score;
        startAnimation();
        changeTouch();
      }).process();

      ground.addChild(listener);
      ground.addChild(tapToStart);
      ground.addChild(scoreDisplay);
      tapToStart.center(listener);
      tapToStart.y = Std.int(Def.area.h * 1.75 - tapToStart.height) >> 1;
      scoreDisplay.bottom(listener);
    };

    retry = function() {
      game.deactivate();
      table.deactivate();
      start();
    };

    gameOver = new GameOverWindow(retry);

    start();
  }

  public function record():Record {
    trace('read');
    return RecordStore.read(game.id);
  }

  public function writeRecord(record:Record) {
    return RecordStore.write(game.id, record);
  }

  public function play(context:BaseContext) {
    var now:BlockBreakerPlayingState = game.play();
    var ball:BallData = now.newBalls.pop();
    while (ball != null) {
      beOnStage(Ball.create(ball));
      ball = now.newBalls.pop();
    }
    if (Configuration.soundEnabled) {
      if (now.blockBroken) {Se.broken.play();}
      if (now.blockHitted) {Se.hit.play();}
    }
    scoreDisplay.score = game.score;
    if (now.state == BlockBreakerState.Played) {
      over();
      return;
    }else if(now.state == BlockBreakerState.Passed){
      pass();
      return;
    }
  }

  private function pass() {
    erase(play);
    stopAnimation();
    changeTouch();
    trace(record());

    var bestScore:Int = record() == null ? 0 : record().score;
    var broke:Bool = game.score > bestScore;
    if (broke) {
      writeRecord({time:0, score:game.score});
    }
    gamePassed = new GamePassedWindow(game.score, bestScore, broke, retry);
    gamePassed.middle(listener);
    gamePassed.activate(this, ground);
  }

  private function over() {
    erase(play);
    stopAnimation();
    changeTouch();
    trace(game.score);
    ground.addChild(gameOver);
    gameOver.center(listener);
    gameOver.middle(listener);
  }

  override public function deactivate() {
    game.deactivate();
    super.deactivate();
  }


  private function changeTouch() {
    trace(game.status.state);
    ground.removeEventListeners(TouchEvent.TOUCH);
    switch(game.status.state){
      case BlockBreakerState.Ready:
        ground.addEventListener(TouchEvent.TOUCH, onReadyTouch);
      case BlockBreakerState.Playing:
        ground.addEventListener(TouchEvent.TOUCH, onPlayingTouch);
      case BlockBreakerState.Played:
      case BlockBreakerState.Passed:
    }
  }

  private function onReadyTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        tapToStart.removeFromParent();

        var p:Point = touch.getLocation(ground);
        var shock:ShockData = game.addShock(p);
        var ballPoint:Point = new Point(p.x, p.y < Def.ballStartTop ? Def.ballStartTop : p.y);
        var newBall:BallData = game.addBall(ballPoint, 270);
        newBall.hittedId = shock.id;
        addBall(newBall);
        addShock(shock);
        game.start();
        write(play);
        changeTouch();
    }
  }


  private function onPlayingTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        var p:Point = touch.getLocation(ground);
        var shock:ShockData = game.addShock(p);
        addShock(shock);
    }
  }

  private function addShock(data:ShockData) {
    var shock:Shock = new Shock(data);
    beOnStage(shock);
  }

  private function addBall(data:BallData) {
    var ball:Ball = Ball.create(data);
    beOnStage(ball);
  }
}
