package context;
import event.ContextEvent;
import starling.events.Event;
import router.RouteData;
import view.common.Button;
import asset.Fa;
import model.common.ButtonProp;
import view.common.PresetButton;
import model.common.CheckboxProp;
import view.NormalBg;
import view.common.Spacer;
import view.common.Label;
import feathers.layout.HorizontalLayout;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import model.common.ActorProp.ActorHorizontal;
import view.common.Checkbox;
import config.Configuration;
import config.Def;
import model.ConfigurationProp;
import model.RouterProp;

using Lambda;

class ConfigurationContext extends BaseContext {
  public function new(props:RouterProp, insertProps:ConfigurationProp = null) {
    super(props);
    ground.y = Def.area.y;
    startAnimation();
    ground.addChild(new NormalBg());

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
    layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    ground.addChild(container);
    container.width = Def.area.w;
    container.height = Def.area.h;

    var title:Label = new Label('Configuration');

    var statusCheck:Checkbox = Checkbox.normal({
      text: 'show status',
      checked: Configuration.statusEnabled,
      prop: new CheckboxProp({position: ActorHorizontal.Right}),
      callback: function(cb:Checkbox) {
        Configuration.statusEnabled = !Configuration.statusEnabled;
        Configuration.save();
      }
    });

    var soundCheck:Checkbox = Checkbox.normal({
      text: 'play sound',
      checked: Configuration.soundEnabled,
      prop: new CheckboxProp({position: ActorHorizontal.Right}),
      callback: function(cb:Checkbox) {
        Configuration.soundEnabled = !Configuration.soundEnabled;
        Configuration.save();
      }
    });

    var finder:Button = PresetButton.forSubmit({
      text: 'go to stage finder',
      prop: new ButtonProp({faChar: Fa.char.th}),
      callback: function() {
        emit(new Event(ContextEvent.SCENE_CHANGE, false, new RouteData('/bb/finder')));
      }
    });

    var maxwidth:Float = 0;
    [statusCheck, soundCheck].map(function(cb:Checkbox) {
      maxwidth = cb.width > maxwidth ? cb.width : maxwidth;
      return cb;
    }).iter(function(cb:Checkbox) {
      cb.resize(maxwidth + 50, 0);
    });



    title.activate(this, container);
    container.addChild(new Spacer(1, 40));
    statusCheck.activate(this, container);
    soundCheck.activate(this, container);
    container.addChild(new Spacer(1, 40));
    finder.activate(this, container);
  }
}
