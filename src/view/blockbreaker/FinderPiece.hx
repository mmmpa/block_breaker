package view.blockbreaker;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import flash.geom.Point;
import asset.Fa;
import model.common.ButtonProp;
import view.common.PresetButton;
import view.common.Button;
import view.common.ButtonListener;
import view.common.Label;
import db.RecordStore.Record;
import starling.display.DisplayObject;
import starling.filters.BlurFilter;
import config.Def;
import db.Palette;
import starling.display.Quad;
import view.common.PartsActor;

using addition.Support;

class FinderPiece extends PartsActor {
  private var bg:Quad = new Quad(Def.innerMinHeight, Def.innerWidth, Palette.white);
  private var ds:BlurFilter = Def.uiDs;
  private var play:Button;
  public var listener:Button;
  private var image:DisplayObject;
  private var masker:Sprite = new Sprite();

  static public function noImage(callback:Dynamic, ?longCallback:Dynamic):FinderPiece {
    return new FinderPiece(new Label('no image'), callback, longCallback);
  }

  static public function loading(callback:Dynamic, ?longCallback:Dynamic):FinderPiece {
    return new FinderPiece(new Label('loading...'), callback, longCallback);
  }

  public function new(image:DisplayObject, callback:Dynamic, ?longCallback:Dynamic) {
    super();
    bg.filter = ds;
    addChild(bg);


    listener = PresetButton.normal({
      text: '',
      callback: callback,
      holdCallback:longCallback
    });

    listener.fit(bg);
    addChild(listener);

    play = PresetButton.forSubmit({
      text: 'play',
      prop: new ButtonProp({faChar: Fa.char.paw}),
      callback: function() {
        callback();
      }
    });

    var buttonArea:Int = Std.int(play.height + (Def.paddingTop << 1)) ;
    play.center(bg);
    play.bottom(bg, -Def.paddingTop);

    masker.mask = new Quad(bg.width, bg.height, 0);
    addChild(masker);
    addChild(play);

    this.image = image;
    image.touchable = false;
    image.center(bg);
    image.middle(bg, -buttonArea >> 1);
    masker.addChild(image);
  }

  public function replaceImage(newImage:Image, fit:Bool = true) {
    image.removeFromParent();
    this.image = newImage;
    newImage.texture;
    image.touchable = false;
    var sx:Int = Std.int(bg.width / image.width);
    var sy:Int = Std.int(bg.height / image.height);
    var detected:Int = sx > sy ? sx : sy;
    image.width *=  detected + 1;
    image.height *= detected + 1;
    image.center(bg);
    image.middle(bg);
    masker.addChild(image);
  }
}
