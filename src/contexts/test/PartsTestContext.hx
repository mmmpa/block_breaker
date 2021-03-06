package contexts.test;
import models.common.CheckboxProp;
import starling.events.Event;
import feathers.events.FeathersEventType;
import feathers.controls.LayoutGroup;
import starling.textures.TextureSmoothing;
import starling.textures.Texture;
import starling.display.Image;
import flash.display.BitmapData;
import services.BitmapLoader;
import views.common.PartsActor;
import starling.display.Sprite;
import views.blockbreaker.FinderPiece;
import views.blockbreaker.GamePassedWindow;
import views.blockbreaker.GameOverWindow;
import feathers.controls.ScrollContainer;
import views.Notification;
import views.common.PresetButton;
import feathers.layout.HorizontalLayout;
import views.NormalBg;
import models.common.ButtonProp;
import models.common.ActorProp;
import views.common.Checkbox;
import configs.Def;
import feathers.layout.VerticalLayout;
import views.common.Label;
import views.common.FaIcon;
import views.common.Button;
import models.RouterProp;

using Lambda;

class PartsTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    this.y = Def.area.y;
    startAnimation();
    addChild(new NormalBg());

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.paddingTop = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;

    var container:LayoutGroup = new LayoutGroup();


    container.layout = layout;

    var scroller:ScrollContainer = new ScrollContainer();
    scroller.width = Def.area.w;
    scroller.height = Def.area.h;
    scroller.addChild(container);
    addChild(scroller);

    scroller.addEventListener(FeathersEventType.SCROLL_START, function(e:Event) {
      //container.flatten();
      container.touchable = false;
    });

    scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(e:Event) {
      //container.unflatten();
      container.touchable = true;
    });

    var parts:Array<Dynamic> = new Array();

    var p1:FinderPiece = FinderPiece.noImage(function() {
      trace('retry');
    });

    var p2:FinderPiece = FinderPiece.loading(function() {
      trace('retry');
    });

    BitmapLoader.load('asset/kobito.png', function(data:BitmapData) {
      var image:Image = new Image(Texture.fromBitmapData(data));
      image.smoothing = TextureSmoothing.NONE;
      p2.replaceImage(image);
    });

    var pieces:PartsActor = new PartsActor();
    pieces.addChild(p1);
    pieces.addChild(p2);
    p2.x = Def.paddingTop + p1.width;

    parts.push(pieces);
    parts.push(new GameOverWindow({
      retryCallback: function() {
        trace('retry');
      },
      backCallback: function() {
        trace('back');
      }
    }));

    parts.push(new GamePassedWindow({
      score: 1000,
      bestScore: 2000,
      recordBroken: false,
      retryCallback: function() { trace('retry'); },
      backCallback: function() { trace('back'); }
    }));

    parts.push(new GamePassedWindow({
      score: 10000,
      bestScore: 2000,
      recordBroken: true,
      retryCallback: function() { trace('retry'); },
      backCallback: function() { trace('back'); }
    }));

    parts.push(PresetButton.normal({
      text: 'normal button',
      callback: function() {
        trace('push');
      }
    }));

    parts.push(PresetButton.normal({
      text: 'button with icon',
      prop: new ButtonProp({char: Smile}),
      callback: function() { trace('push'); }
    }));

    parts.push(PresetButton.forOk({
      text: 'ok',
      prop: new ButtonProp({char: Thumbs26}),
      callback: function() { trace('push'); }
    }));

    parts.push(PresetButton.forSubmit({
      text: 'submit',
      prop: new ButtonProp({char: Thumbs26}),
      callback: function() { trace('push'); }
    }));

    parts.push(PresetButton.forCansel({
      text: 'cancel',
      prop: new ButtonProp({char: Ban}),
      callback: function() { trace('push'); }
    }));

    parts.push(Checkbox.normal({
      text: 'checked box',
      checked: true,
      prop: new CheckboxProp({position: ActorHorizontal.Right}),
      callback: function(cb:Checkbox) {
        trace(cb.checked);
      }
    }));

    parts.push(Checkbox.normal({
      text: 'unchecked box',
      checked: false,
      prop: new CheckboxProp({position: ActorHorizontal.Left}),
      callback: function(cb:Checkbox) {
        trace(cb.checked);
      }
    }));

    parts.push(new Notification('', 'message only', function() { trace('push');}));
    parts.push(new Notification('title', 'and message', function() {trace('push');}));
    parts.push(new Notification('On death', "Can death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n", function() {trace('push');}));
    parts.push(new Notification('On death', "Can death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n\nHow strange it is that man on earth should roam,And lead a life of woe, but not forsake His rugged path; nor dare he view alone His future doom which is but to awake.\nCan death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n\nHow strange it is that man on earth should roam,And lead a life of woe, but not forsake His rugged path; nor dare he view alone His future doom which is but to awake.", function() {trace('push');}));

    parts.push(new FaIcon(Apple22, 56).scale(2).rotate(0));
    parts.push(new Label('ラベル', 20, Apple22));

    parts.iter(function(actor:Dynamic) {
      actor.activate(this, container);
    });


  }
}
