package contexts.blockbreaker;
import configs.Configuration;
import assets.Se;
import views.blockbreaker.GameOver;
import models.blockbreaker.BlockBreakerState;
import views.blockbreaker.TapToStart;
import views.NormalBg;
import models.blockbreaker.BlockBreakerPlayingState;
import models.blockbreaker.BlockBreakerProp;
import models.blockbreaker.BallData;
import models.blockbreaker.BlockBreaker;
import models.blockbreaker.ShockData;
import views.blockbreaker.Shock;
import views.blockbreaker.BlockTable;
import models.blockbreaker.BlockGrid;
import views.blockbreaker.Ball;
import starling.events.TouchPhase;
import starling.display.Quad;
import configs.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import models.RouterProp;

using Lambda;

class PlainBlockBreakerContext extends BaseContext {

  private var game:BlockBreaker;
  private var listener:Quad;
  private var tapToStart:TapToStart = new TapToStart();
  private var gameOver:GameOver = new GameOver();

  public function new(props:RouterProp, insertProps:BlockBreakerProp) {
    super(props);
    this.y = Def.area.y;
    listener = new NormalBg();

    var grid:BlockGrid = insertProps.grid;
    game = new BlockBreaker({
      id: insertProps.id,
      grid: grid,
      speed: Def.ballSpeedNormal,
      field: Def.gameField
    });

    addChild(listener);
    addChild(tapToStart);
    tapToStart.x = Std.int(Def.area.w - tapToStart.width) >> 1;
    tapToStart.y = Std.int(Def.area.h * 1.5 - tapToStart.height) >> 1;

    var table:BlockTable = new BlockTable(grid);
    addActor(table, true);
    changeTouch();

    startAnimation();
  }

  public function play(context:BaseContext) {
    var now:BlockBreakerPlayingState = game.play();
    if(now.state == BlockBreakerState.Played){
      over();
      return;
    }
    var ball:BallData = now.newBalls.pop();
    while (ball != null) {
      addActor(Ball.create(ball));
      ball = now.newBalls.pop();
    }
    if (Configuration.soundEnabled) {
      if (now.blockBroken) {Se.broken.play();}
      if (now.blockHitted) {Se.hit.play();}
    }
  }

  private function over(){
    stopAnimation();
    changeTouch();

    addChild(gameOver);
    gameOver.x = Std.int(Def.area.w - gameOver.width) >> 1;
    gameOver.y = Std.int(Def.area.h - gameOver.height) >> 1;
  }

  override public function deactivate() {
    game.deactivate();
    super.deactivate();
  }


  private function changeTouch() {
    removeEventListeners(TouchEvent.TOUCH);
    switch(game.status.state){
      case BlockBreakerState.Ready:
        addEventListener(TouchEvent.TOUCH, onReadyTouch);
      case BlockBreakerState.Playing:
        addEventListener(TouchEvent.TOUCH, onPlayingTouch);
      case BlockBreakerState.Played:
      case BlockBreakerState.Passed:
    }
  }

  private function onReadyTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(this);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        tapToStart.removeFromParent();

        var p:Point = touch.getLocation(this);
        var shock:ShockData = game.addShock(p);
        var ballPoint:Point = new Point(p.x, p.y < Def.ballStartTop ? Def.ballStartTop : p.y);
        var newBall:BallData = game.addBall(ballPoint, 270);
        newBall.hittedId = shock.id;
        addBall(newBall);
        addShock(shock);
        game.start();
        addBook(play);
        changeTouch();
    }
  }


  private function onPlayingTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(this);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        var p:Point = touch.getLocation(this);
        var shock:ShockData = game.addShock(p);
        addShock(shock);
    }
  }

  private function addShock(data:ShockData) {
    var shock:Shock = new Shock(data);
    addActor(shock);
  }

  private function addBall(data:BallData) {
    var ball:Ball = Ball.create(data);
    addActor(ball);
  }
}
