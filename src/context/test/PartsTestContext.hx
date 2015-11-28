package context.test;
import starling.events.Event;
import feathers.events.FeathersEventType;
import feathers.controls.LayoutGroup;
import starling.textures.TextureSmoothing;
import starling.textures.Texture;
import starling.display.Image;
import flash.display.BitmapData;
import service.BitmapLoader;
import view.common.PartsActor;
import starling.display.Sprite;
import view.blockbreaker.FinderPiece;
import view.blockbreaker.GamePassedWindow;
import view.blockbreaker.GameOverWindow;
import feathers.controls.ScrollContainer;
import view.Notification;
import view.common.PresetButton;
import feathers.layout.HorizontalLayout;
import view.NormalBg;
import model.common.ButtonProp;
import model.common.ActorProp;
import view.common.Checkbox;
import config.Def;
import feathers.layout.VerticalLayout;
import view.common.Label;
import asset.Fa;
import view.common.FaIcon;
import view.common.Button;
import model.RouterProp;

using Lambda;

class PartsTestContext extends BaseContext {

  public function new(props:RouterProp, insertProps:Dynamic = null) {
    super(props);
    ground.y = Def.area.y;
    startAnimation();
    ground.addChild(new NormalBg());

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
    ground.addChild(scroller);

    scroller.addEventListener(FeathersEventType.SCROLL_START, function(e:Event){
      container.flatten();
      container.touchable = false;
    });

    scroller.addEventListener(FeathersEventType.SCROLL_COMPLETE, function(e:Event){
      container.unflatten();
      container.touchable = true;
    });

    var parts:Array<Dynamic> = new Array();
    var fab:ButtonProp = new ButtonProp();
    fab.faChar = Fa.char.paw;
    var thum:ButtonProp = new ButtonProp();
    thum.faChar = Fa.char.thumbsOUp;
    var ban:ButtonProp = new ButtonProp();
    ban.faChar = Fa.char.ban;


    var p1:FinderPiece = FinderPiece.noImage(function() {
      trace('retry');
    });
    var p2:FinderPiece = FinderPiece.loading(function() {
      trace('retry');
    });
    BitmapLoader.load('asset/kobito.png', function(data:BitmapData){
      var image:Image = new Image(Texture.fromBitmapData(data));
      image.smoothing = TextureSmoothing.NONE;
      p2.replaceImage(image);
    });
    var pieces:PartsActor = new PartsActor();
    pieces.addChild(p1);
    pieces.addChild(p2);
    p2.x = Def.paddingTop + p1.width;

    parts.push(pieces);
    parts.push(new GameOverWindow(function() {
      trace('retry');
    }));
    parts.push(new GamePassedWindow(1000, 2000, false, function() {
      trace('retry');
    }));
    parts.push(new GamePassedWindow(10000, 10000, true, function() {
      trace('retry');
    }));
    parts.push(PresetButton.normal('normal button', null, function() {
      trace('push');
    }));
    parts.push(PresetButton.normal('button with icon', fab, function() {
      trace('push');
    }));
    parts.push(PresetButton.forOk('ok', thum, function() {
      trace('push');
    }));
    parts.push(PresetButton.forSubmit('submit', thum, function() {
      trace('push');
    }));
    parts.push(PresetButton.forCansel('cancel', ban, function() {
      trace('push');
    }));
    parts.push(Checkbox.normal('checked box', true, ActorHorizontal.Right, function(cb:Checkbox) {
      trace(cb.checked);
    }));
    parts.push(Checkbox.normal('unchecked box', false, ActorHorizontal.Left, function(cb:Checkbox) {
      trace(cb.checked);
    }));

    parts.push(new Notification('', 'message only', function() { trace('push');}));
    parts.push(new Notification('title', 'and message', function() {trace('push');}));
    parts.push(new Notification('On death', "Can death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n", function() {trace('push');}));
    parts.push(new Notification('On death', "Can death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n\nHow strange it is that man on earth should roam,And lead a life of woe, but not forsake His rugged path; nor dare he view alone His future doom which is but to awake.\nCan death be sleep, when life is but a dream, And scenes of bliss pass as a phantom by? The transient pleasures as a vision seem,\nAnd yet we think the greatest pain's to die.\n\nHow strange it is that man on earth should roam,And lead a life of woe, but not forsake His rugged path; nor dare he view alone His future doom which is but to awake.", function() {trace('push');}));

    parts.push(new FaIcon(Fa.char.apple, 56).scale(2).rotate(0));
    parts.push(new Label('ラベル', 20, Fa.char.apple));

    parts.iter(function(actor:Dynamic) {
      actor.activate(this, container);
    });


  }
}
