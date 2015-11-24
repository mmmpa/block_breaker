package context;
import asset.Se;
import view.common.Spacer;
import view.common.Label;
import feathers.layout.HorizontalLayout;
import feathers.layout.HorizontalSpinnerLayout;
import feathers.controls.LayoutGroup;
import feathers.layout.VerticalLayout;
import model.common.ActorProp.ActorHorizontal;
import view.common.Checkbox;
import config.Configuration;
import view.common.Button;
import config.Def;
import model.ConfigurationProp;
import starling.events.Event;
import starling.text.TextField;
import model.RouterProp;
import event.ContextEvent;

using Lambda;

class ConfigurationContext extends BaseContext {
  public function new(props:RouterProp, insertProps:ConfigurationProp = null) {
    super(props);
    ground.y = Def.area.y;
    startAnimation();

    var layout:VerticalLayout = new VerticalLayout();
    layout.gap = 20;
    layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
    layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
    var container:LayoutGroup = new LayoutGroup();
    container.layout = layout;
    ground.addChild(container);
    container.width = Def.area.w;
    container.height = Def.area.h;

    var title:Label = new Label('setup');

    var statusCheck:Checkbox = Checkbox.normal('show status', Configuration.statusEnabled, ActorHorizontal.Right, function(cb:Checkbox) {
      Configuration.statusEnabled = !Configuration.statusEnabled;
      Configuration.save();
    });

    var soundCheck:Checkbox = Checkbox.normal('play sound', Configuration.soundEnabled, ActorHorizontal.Right, function(cb:Checkbox) {
      Configuration.soundEnabled = !Configuration.soundEnabled;
      Configuration.save();
    });

    var maxwidth:Float = 0;
    [statusCheck, soundCheck].map(function(cb:Checkbox){
      maxwidth = cb.width > maxwidth ? cb.width : maxwidth;
      return cb;
    }).iter(function(cb:Checkbox){
      cb.resize(maxwidth + 50, 0);
    });


    title.activate(this, container);
    container.addChild(new Spacer(1,40));
    statusCheck.activate(this, container);
    soundCheck.activate(this, container);
  }
}
