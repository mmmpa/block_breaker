package context.test;
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

    var container:ScrollContainer = new ScrollContainer();
    container.layout = layout;
    container.width = Def.area.w;
    container.height = Def.area.h;
    ground.addChild(container);

    var parts:Array<Dynamic> = new Array();
    var fab:ButtonProp = new ButtonProp();
    fab.faChar = Fa.char.paw;
    var thum:ButtonProp = new ButtonProp();
    thum.faChar = Fa.char.thumbsOUp;
    var ban:ButtonProp = new ButtonProp();
    ban.faChar = Fa.char.ban;

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
