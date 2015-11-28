package context.blockbreaker;
import view.blockbreaker.FinderPiece;
import view.blockbreaker.FinderPiece;
import model.blockbreaker.FinderProp;
import starling.events.Event;
import feathers.events.FeathersEventType;
import feathers.controls.ScrollContainer;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
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

class FinderContext extends BaseContext {

  private var game:BlockBreaker;
  private var table:BlockTable;
  private var listener:Quad;
  private var tapToStart:TapToStart = new TapToStart();
  private var gameOver:GameOverWindow;
  private var scoreDisplay:ScoreDisplay = new ScoreDisplay();
  private var gamePassed:GamePassedWindow;
  private var retry:Dynamic;

  public function new(props:RouterProp, insertProps:FinderProp) {
    super(props);
    ground.y = Def.area.y;
    listener = new NormalBg();

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.paddingTop = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;

    var container:LayoutGroup = new LayoutGroup();
    container.width = Def.area.w;
    container.layout = layout;

    var scroller:ScrollContainer = new ScrollContainer();
    scroller.width = Def.area.w;
    scroller.height = Def.area.h;
    scroller.addChild(container);
    ground.addChild(scroller);

    scroller.addEventListener(FeathersEventType.SCROLL_START, function(e:Event){
      container.flatten();
      container.touchable = false;
    });

    scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(e:Event){
      container.unflatten();
      container.touchable = true;
    });

    insertProps.games.iter(function(data:BlockBreakerRouteProp){
      var child:FinderPiece = FinderPiece.loading(function() {
        trace('retry');
      });
      container.addChild(child);
    });
  }
}
