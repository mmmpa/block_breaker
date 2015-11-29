package context.blockbreaker;
import config.Configuration;
import asset.Se;
import view.blockbreaker.GameOver;
import model.blockbreaker.BlockBreakerState;
import view.blockbreaker.TapToStart;
import view.NormalBg;
import model.blockbreaker.BlockBreakerPlayingState;
import model.blockbreaker.BlockBreakerProp;
import model.blockbreaker.BallData;
import model.blockbreaker.BlockBreaker;
import model.blockbreaker.ShockData;
import view.blockbreaker.Shock;
import view.blockbreaker.BlockTable;
import model.blockbreaker.BlockGrid;
import view.blockbreaker.Ball;
import starling.events.TouchPhase;
import starling.display.Quad;
import config.Def;
import flash.geom.Point;
import starling.events.Touch;
import starling.events.TouchEvent;
import model.RouterProp;

using Lambda;

class PlainBlockBreakerContext extends BaseContext {

  private var game:BlockBreaker;
  private var listener:Quad;
  private var tapToStart:TapToStart = new TapToStart();
  private var gameOver:GameOver = new GameOver();

  public function new(props:RouterProp, insertProps:BlockBreakerProp) {
    super(props);
    ground.y = Def.area.y;
    listener = new NormalBg();

    var grid:BlockGrid = insertProps.grid;
    game = new BlockBreaker({
      id: insertProps.id,
      grid: grid,
      speed: Def.ballSpeedNormal,
      field: Def.gameField
    });

    ground.addChild(listener);
    ground.addChild(tapToStart);
    tapToStart.x = Std.int(Def.area.w - tapToStart.width) >> 1;
    tapToStart.y = Std.int(Def.area.h * 1.5 - tapToStart.height) >> 1;

    var table:BlockTable = new BlockTable(grid);
    beOnStage(table, true);
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
      beOnStage(Ball.create(ball));
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

    ground.addChild(gameOver);
    gameOver.x = Std.int(Def.area.w - gameOver.width) >> 1;
    gameOver.y = Std.int(Def.area.h - gameOver.height) >> 1;
  }

  override public function deactivate() {
    game.deactivate();
    super.deactivate();
  }


  private function changeTouch() {
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
