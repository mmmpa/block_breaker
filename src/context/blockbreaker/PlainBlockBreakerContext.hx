package context.blockbreaker;
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

  public function new(props:RouterProp, insertProps:BlockBreakerProp) {
    super(props);
    ground.y = Def.area.y;

    listener = new NormalBg();
    ground.addChild(listener);
    ground.addEventListener(TouchEvent.TOUCH, onTouch);

    var grid:BlockGrid = insertProps.grid;
    var table:BlockTable = new BlockTable(grid);
    game = new BlockBreaker(grid);
    beOnStage(table, true);

    write(play);
    startAnimation();
  }

  public function play(context:BaseContext){
    var now:BlockBreakerPlayingState = game.play();
    var ball:BallData = now.newBalls.pop();
    while(ball != null){
      beOnStage(Ball.create(ball));
      ball = now.newBalls.pop();
    }
  }

  override public function deactivate(){
    game.deactivate();
    super.deactivate();
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(ground);

    switch(touch.phase){
      case TouchPhase.BEGAN:
        var p:Point = touch.getLocation(ground);
        var shock:ShockData = game.addShock(p);
        if (game.noBall()) {
          var ballPoint:Point = new Point(p.x, p.y < Def.ballStartTop ? Def.ballStartTop : p.y);
          var newBall:BallData = game.addBall(ballPoint, 270);
          newBall.hittedId = shock.id;
          addBall(newBall);
          addShock(shock);
        }else{
          addShock(shock);
        }
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
