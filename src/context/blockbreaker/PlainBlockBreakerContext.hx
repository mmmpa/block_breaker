package context.blockbreaker;
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

    listener = new Quad(Def.area.w, Def.area.h, 0xcccccc);
    ground.addChild(listener);
    ground.addEventListener(TouchEvent.TOUCH, onTouch);

    var grid:BlockGrid = insertProps.grid;
    var table:BlockTable = new BlockTable(grid);
    game = new BlockBreaker(grid);
    beOnStage(table, true);

    write(game.play);
    startAnimation();
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
        if (game.noBall()) {
          var ballPoint:Point = new Point(p.x, p.y < Def.ballStartTop ? Def.ballStartTop : p.y);
          var ball:BallData = game.addBall(ballPoint, 270);
          var shock:ShockData = game.addShock(p);
          ball.hittedId = shock.id;
        }else{
          addShock(p);
        }
    }
  }

  private function addShock(p:Point):ShockData {
    var data:ShockData = game.addShock(p);
    var shock:Shock = new Shock(data);
    beOnStage(shock);
    return data;
  }

  private function addBall(p:Point, degree:Int, color:Int = 0):BallData {
    var data:BallData = game.addBall(p, degree, color);
    var ball:Ball = Ball.create(data);
    return data;
  }
}
