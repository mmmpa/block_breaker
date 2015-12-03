package contexts;
import events.ContextEvent;
import starling.events.Event;
import routers.RouteData;
import views.common.Button;
import models.common.ButtonProp;
import views.common.PresetButton;
import models.common.CheckboxProp;
import views.NormalBg;
import views.common.Spacer;
import views.common.Label;
import feathers.layout.HorizontalLayout;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import models.common.ActorProp.ActorHorizontal;
import views.common.Checkbox;
import configs.Configuration;
import configs.Def;
import models.ConfigurationProp;
import models.RouterProp;

using Lambda;

class ConfigurationContext extends BaseContext {
  public function new(props:RouterProp, insertProps:ConfigurationProp = null) {
    super(props);
    this.y = Def.area.y;
    startAnimation();
    addChild(new NormalBg());

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
    layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    addChild(container);
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
      prop: new ButtonProp({char: Four29}),
      callback: function() {
        go(new RouteData('/bb/finder'));
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
