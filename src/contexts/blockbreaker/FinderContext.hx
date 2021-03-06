package contexts.blockbreaker;
import models.blockbreaker.FinderPieceProp;
import routers.SceneChangeData;
import starling.textures.Texture;
import starling.display.Image;
import flash.display.BitmapData;
import starling.textures.TextureSmoothing;
import services.BitmapLoader;
import starling.display.Sprite;
import views.blockbreaker.FinderPiece;
import models.blockbreaker.FinderProp;
import starling.events.Event;
import feathers.events.FeathersEventType;
import feathers.controls.ScrollContainer;
import feathers.controls.LayoutGroup;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;
import views.blockbreaker.GamePassedWindow;
import views.blockbreaker.ScoreDisplay;
import views.blockbreaker.GameOverWindow;
import views.blockbreaker.BlockTable;
import models.blockbreaker.ImageBlockBreakerProp;
import views.blockbreaker.TapToStart;
import views.NormalBg;
import models.blockbreaker.BlockBreaker;
import starling.display.Quad;
import configs.Def;
import models.RouterProp;

using Lambda;
using additions.Support;

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
    this.y = Def.area.y;
    listener = new NormalBg();
    addChild(listener);

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
    addChild(scroller);

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
        var route:SceneChangeData = new SceneChangeData('/bb/image', new ImageBlockBreakerProp(data.id, data.blockImagePath), true);
        go(route);
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

