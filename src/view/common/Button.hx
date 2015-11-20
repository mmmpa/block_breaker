package view.common;
import asset.Fa;
import model.common.ButtonProp;
import context.BaseContext;
import starling.text.TextFieldAutoSize;
import db.Palette;
import starling.events.TouchEvent;
import starling.events.Touch;
import flash.geom.Point;
import starling.events.TouchPhase;
import addition.Def;
import starling.display.DisplayObjectContainer;
import starling.text.TextField;
import flash.geom.Rectangle;
import starling.display.Quad;
import starling.display.Sprite;

using addition.NullOr;

class Button extends Sprite {
  private var bg:Quad;
  private var effect:Quad;
  private var tf:TextField;
  private var prop:ButtonProp;

  private var callback:Dynamic;
  //private var Map<Dynamic, CallbackList>;

  public static function normal(callback:Dynamic, ?text:String, ?color:Int, ?effect:Int):Button {
    var prop:ButtonProp = new ButtonProp();
    return new Button(
    callback,
    prop,
    text.or('Button'),
    Std.int(color.or(Palette.gray)),
    Std.int(effect.or(Palette.grayD))
    );
  }

  public function new(callback:Dynamic, prop:ButtonProp, text:String, color:Int, effect:Int) {
    super();
    this.callback = callback;
    this.prop = prop;
    this.tf = new TextField(1, 1, text);
    this.bg = new Quad(1, 1, color);
    this.effect = new Quad(1, 1, effect);

    this.addChild(bg);
    this.addChild(tf);

    initialize();
  }

  public function initialize(){
    tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
    tf.fontName = Fa.name;
    tf.text = Fa.char.apple;

    tf.x = prop.paddingSide;
    tf.y = prop.paddingTop;

    if(prop.width != 0){
      bg.width = prop.width;
    }else{
      bg.width = Std.int(tf.width) + (prop.paddingSide << 1);
    }

    if(prop.height != 0){
      bg.height = prop.height;
    }else{
      bg.height = Std.int(tf.height) + (prop.paddingTop << 1);
    }

    trace([bg.width, bg.height]);
  }

  private function onTouch(e:TouchEvent) {
    var touch:Touch = e.getTouch(this);
    var position:Point = touch.getLocation(this);

    switch(touch.phase){
      case TouchPhase.ENDED:
        trace(position);
        callback();
    }
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer) {
    this.addEventListener(TouchEvent.TOUCH, onTouch);
    parent.addChild(this);
  }

  public function deactivate() {
    this.removeEventListeners();
    removeFromParent();
  }

  public function act():Bool {

    return true;
  }
}
