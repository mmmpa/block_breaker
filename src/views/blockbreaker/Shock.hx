package views.blockbreaker;

import flash.display.StageQuality;
import configs.Def;
import starling.display.DisplayObjectContainer;
import contexts.BaseContext;
import starling.display.Image;
import starling.textures.Texture;
import models.blockbreaker.ShockData;
import flash.display.BitmapData;

class Shock extends Image {
  public static var _tex:Texture;

  public var data:ShockData;

  static public function tex():Texture {
    if (_tex != null) {
      return _tex;
    }
    Def.rawStage.quality = StageQuality.BEST;
    var sp:flash.display.Sprite = new flash.display.Sprite();
    var g:flash.display.Graphics = sp.graphics;
    var lineHalf:Int = Def.shockThickness >> 1;
    var sizeHalf:Int = Def.shockSize >> 1;
    var drawSize:Int = sizeHalf - lineHalf;
    g.lineStyle(Def.shockThickness, Def.shockColor);
    g.drawCircle(sizeHalf, sizeHalf, drawSize);
    var bd:BitmapData = new BitmapData(Def.shockSize , Def.shockSize, true, 0);
    bd.draw(sp);
    Def.rawStage.quality = StageQuality.LOW;

    return _tex = Texture.fromBitmapData(bd);
  }

  public function new(data:ShockData) {
    super(tex());
    this.data = data;
    reposit();
  }

  public function reposit() {
    this.x = data.x - data.size;
    this.y = data.y - data.size;
    this.width = data.size * 2;
    this.height = data.size * 2;
  }

  public function act(){
    reposit();
    return isAlive();
  }

  public function isAlive():Bool {
    return !data.isCompleted();
  }

  public function activate(context:BaseContext, parent:DisplayObjectContainer):Shock {
    parent.addChild(this);
    return this;
  }

  public function deactivate():Shock {
    this.removeFromParent();
    return this;
  }
}
