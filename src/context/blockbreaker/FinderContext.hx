package context.blockbreaker;
import model.blockbreaker.BlockBreakerType;
import model.blockbreaker.FinderPieceProp;
import event.ContextEvent;
import router.RouteData;
import router.RouteData;
import starling.textures.Texture;
import starling.display.Image;
import flash.display.BitmapData;
import starling.textures.TextureSmoothing;
import service.BitmapLoader;
import view.common.Spacer;
import starling.display.Sprite;
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

typedef FinderImage = {finder:FinderPiece, path:String};

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
    ground.addChild(listener);

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = Def.paddingTop;
    layout.paddingTop = Def.paddingTop;
    layout.paddingBottom = Def.paddingTop;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;

    var container:LayoutGroup = new LayoutGroup();
    container.width = Def.area.w;
    container.layout = layout;

    var scroller:ScrollContainer = new ScrollContainer();
    scroller.width = Def.area.w;
    scroller.height = Def.area.h;
    scroller.addChild(container);
    ground.addChild(scroller);

    scroller.addEventListener(FeathersEventType.SCROLL_START, function(e:Event) {
      container.flatten();
      container.touchable = false;
    });

    scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(e:Event) {
      container.unflatten();
      container.touchable = true;
    });

    var loading:Array<FinderImage> = new Array();
    var newLine:Bool = true;
    var line:Sprite = null;
    insertProps.games.iter(function(data:FinderPieceProp) {
      if (newLine) {
        line = new Sprite();
        line.y = container.height + Def.paddingTop;
        container.addChild(line);
      }
      var child:FinderPiece = FinderPiece.loading(function() {
        var route:RouteData = new RouteData('/bb/image', new ImageBlockBreakerProp(data.id, data.blockImagePath), true);
        emit(new Event(ContextEvent.SCENE_CHANGE, false, route));
      });
      loading.push({finder: child, path: data.thumnailPath});
      line.addChild(child);
      if (!newLine) {
        child.x = line.width + Def.paddingTop;
      }
      newLine = !newLine;
    });

    loadImage(loading);
  }

  public function loadImage(loading:Array<FinderImage>) {
    if (loading.length == 0) {
      return;
    }
    var target:FinderImage = loading.shift();
    BitmapLoader.load(target.path, function(data:BitmapData) {
      var image:Image = new Image(Texture.fromBitmapData(data));
      image.smoothing = TextureSmoothing.NONE;
      target.finder.replaceImage(image);
      loadImage(loading);
    });
  }
}

