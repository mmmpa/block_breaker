package contexts.blockbreaker;
import views.common.Spacer;
import models.blockbreaker.PlayFieldData;
import views.blockbreaker.Calm;
import routers.SceneChangeData;
import views.blockbreaker.GamePassedWindow;
import dbs.RecordStore;
import views.blockbreaker.ScoreDisplay;
import views.blockbreaker.GameOverWindow;
import views.blockbreaker.BlockTable;
import models.blockbreaker.BlockGrid;
import models.blockbreaker.ImageBlockGrid;
import models.blockbreaker.ImageBlockBreakerProp;
import configs.Configuration;
import assets.Se;
import models.blockbreaker.BlockBreakerState;
import views.blockbreaker.TapToStart;
import views.NormalBg;
import models.blockbreaker.BlockBreakerPlayingState;
import models.blockbreaker.BallData;
import models.blockbreaker.BlockBreaker;
import models.blockbreaker.ShockData;
import views.blockbreaker.Shock;
import views.blockbreaker.Ball;
import starling.events.TouchPhase;
import starling.display.Quad;
import configs.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import models.RouterProp;

using Lambda;
using additions.Support;

enum AnimationState {
  Playing;
  Pause;
  Stoped;
}

class ImageBlockBreakerContext extends BaseContext {

  private var animationState:AnimationState;

  private var game:BlockBreaker;
  private var table:BlockTable;
  private var bg:NormalBg;
  private var deadBg:Quad;
  private var listener:Spacer;
  private var calm:Calm = new Calm();
  private var tapToStart:TapToStart = new TapToStart();
  private var gameOver:GameOverWindow;
  private var scoreDisplay:ScoreDisplay = new ScoreDisplay();
  private var gamePassed:GamePassedWindow;
  private var retry:Dynamic;
  private var back:Dynamic;

  public function new(props:RouterProp, insertProps:ImageBlockBreakerProp) {
    super(props);
    deadBg = new Quad(Def.area.w, Def.area.h, Def.deadBg);
    addChild(deadBg);
    this.y = Def.area.y;
    listener = new Spacer(Def.gameArea.w, Def.gameArea.h);
    bg = new NormalBg();
    calm.touchable = false;
    bg.shape(Def.gameArea.w, Def.gameArea.h);

    calm.addChild(bg);
    calm.center(deadBg);
    listener.y = Def.area.y;
    //calm.bottom(deadBg);
    listener.center(deadBg);
    listener.y = Def.area.y;
    //listener.bottom(deadBg);

    addEventListener('pause', function() {
      if(animationState == AnimationState.Playing){
        stopAnimation();
        animationState = AnimationState.Pause;
      }
    });
    addEventListener('resume', function() {
      if(animationState == AnimationState.Pause){
        startAnimation();
        animationState = AnimationState.Playing;
      }
    });


    var start:Dynamic = function() {
      new ImageBlockGrid(insertProps.path, function(grid:BlockGrid) {
        game = new BlockBreaker({
          id: insertProps.id,
          grid: grid,
          speed: Def.ballSpeedNormal,
          field: Def.gameField
        });
        table = new BlockTable(grid);
        table.activate(this, calm);
        scoreDisplay.score = game.score;
        startAnimation();
        animationState = AnimationState.Playing;
        changeTouch();
      }).process();

      addChild(listener);
      addChild(calm);
      calm.addChild(scoreDisplay);
      calm.addChild(tapToStart);

      tapToStart.center(bg);
      tapToStart.y = Std.int(Def.gameArea.h * 1.75 - tapToStart.height) >> 1;
      scoreDisplay.bottom(bg);
    };

    retry = function() {
      game.deactivate();
      table.deactivate();
      removeAllActors();
      start();
    };

    back = function() {
      go(new SceneChangeData('/bb/finder'));
    };

    start();
  }

  public function record():Record {
    return RecordStore.read(game.id);
  }

  public function writeRecord(record:Record) {
    return RecordStore.write(game.id, record);
  }

  public function play(context:BaseContext) {
    var now:BlockBreakerPlayingState = game.play();
    var ball:BallData = now.newBalls.pop();
    while (ball != null) {
      addBall(ball);
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
    } else if (now.state == BlockBreakerState.Passed) {
      pass();
      return;
    }
  }

  private function pass() {
    removeTask(play);
    stopAnimation();
    animationState = AnimationState.Stoped;
    changeTouch();

    var bestScore:Int = record() == null ? 0 : record().score;
    var broke:Bool = game.score > bestScore;
    if (broke) { writeRecord({time:0, score:game.score}); }
    gamePassed = new GamePassedWindow({
      score:game.score,
      bestScore:bestScore,
      recordBroken: broke,
      retryCallback: retry,
      backCallback: back
    });
    gamePassed.center(deadBg);
    gamePassed.middle(deadBg);
    gamePassed.activate(this, this);
  }

  private function over() {
    removeTask(play);
    stopAnimation();
    animationState = AnimationState.Stoped;
    changeTouch();
    trace(game.score);

    gameOver = new GameOverWindow({retryCallback: retry, backCallback: back});
    gameOver.center(deadBg);
    gameOver.middle(deadBg);
    gameOver.activate(this, this);
  }

  override public function deactivate() {
    game.deactivate();
    super.deactivate();
  }


  private function changeTouch() {
    listener.removeEventListeners(TouchEvent.TOUCH);
    switch(game.status.state){
      case BlockBreakerState.Ready:
        listener.addEventListener(TouchEvent.TOUCH, onReadyTouch);
      case BlockBreakerState.Playing:
        listener.addEventListener(TouchEvent.TOUCH, onPlayingTouch);
      case BlockBreakerState.Played:
      case BlockBreakerState.Passed:
    }
  }

  private function onReadyTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(listener);
    if (touch == null) {return;}

    switch(touch.phase){
      case TouchPhase.BEGAN:
        tapToStart.removeFromParent();

        var p:Point = touch.getLocation(listener);
        var shock:ShockData = game.addShock(p);
        var ballPoint:Point = new Point(p.x, p.y < Def.ballStartTop ? Def.ballStartTop : p.y);
        trace(ballPoint);
        var newBall:BallData = game.addBall(ballPoint, 270);
        newBall.hittedId = shock.id;
        addBall(newBall);
        addShock(shock);
        game.start();
        addTask(play);
        changeTouch();
    }
  }


  private function onPlayingTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(listener);
    if (touch == null) {return;}

    switch(touch.phase){
      case TouchPhase.BEGAN:
        var p:Point = touch.getLocation(listener);
        var shock:ShockData = game.addShock(p);
        addShock(shock);
    }
  }

  private function addShock(data:ShockData) {
    addActor(new Shock(data), false, calm);
  }

  private function addBall(data:BallData) {
    addActor(Ball.create(data), false, calm);
  }
}
