package view.common;

import model.common.ButtonProp;
import starling.filters.BlurFilter;
import db.Palette;
import starling.display.Quad;
import feathers.layout.VerticalLayout;
import config.Def;
import feathers.controls.ScrollContainer;
import starling.display.DisplayObjectContainer;
import event.ContextEvent;
import starling.events.Event;
import router.RouteData;

using Lambda;
using addition.NullOr;

typedef MenuRecipe = {icon:String, text:String, route:RouteData}

enum SideMenuState {
  Ready;
  Closed;
  PreOpening;
  Opening;
  Opened;
  Closing;
}

class SideMenu extends BaseActor {
  public var menuRecipes:Array<MenuRecipe>;
  public var maxWidth:Float = 0;
  public var buttons:Array<Button> = new Array();
  public var state:SideMenuState = SideMenuState.Closed;
  public var sield:ButtonListener;

  // state getter
  public var closed(get, never):Bool;
  public var opening(get, never):Bool;
  public var opened(get, never):Bool;
  public var closing(get, never):Bool;

  public function new(menuRecipes) {
    super();

    this.menuRecipes = menuRecipes;

    var container:ScrollContainer = new ScrollContainer();
    var layout:VerticalLayout = new VerticalLayout();
    container.layout = layout;

    makeButtons().iter(function(button:Button) {
      container.addChild(button);
      container.addChild(new Quad(button.width, 1, Palette.whiteGrayD));
    });

    var bg:Quad = new Quad(maxWidth, Def.fullArea.h, Palette.whiteGrayD);
    var ds:BlurFilter = BlurFilter.createDropShadow(2, Math.PI / 6, Def.uiShadow, 0.3);

    bg.filter = ds;
    container.width = maxWidth;
    container.height = Def.fullArea.h;

    sield = new ButtonListener(Def.fullArea.w, Def.fullArea.h, 0.5);
    sield.down = function() {
      close();
    }
    this.addChild(bg);
    this.addChild(container);
  }

  override public function act():Bool {
    switch(state){
      case SideMenuState.Closed:
        if (parent.be()) {
          sield.removeFromParent();
          removeFromParent();
        }
        this.x = -this.width - 2;
        trace('closed');
        state = SideMenuState.Ready;
      case SideMenuState.PreOpening:
        context.ground.addChild(sield);
        context.beOnStage(this, true);
        state = SideMenuState.Opening;
      case SideMenuState.Opening:
        this.x = Std.int(this.x / 2);
        if (this.x == 0) {
          state = SideMenuState.Opened;
        }
      case SideMenuState.Opened:
        this.x = 0;
        state = SideMenuState.Ready;
      case SideMenuState.Closing:
        sield.removeFromParent();
        this.x = Std.int((-this.width - 2 + this.x) / 2) - 1;
        if (this.x == -this.width - 2) {
          state = SideMenuState.Closed;
        }
      case SideMenuState.Ready:
    }

    return true;
  }

  public function open() {
    if (!opened) { state = SideMenuState.PreOpening; }
  }

  public function close() {
    if (!closed) {state = SideMenuState.Closing;}
  }

  override public function deactivate() {
    buttons.iter(function(button:Button) {
      button.deactivate();
    });
    buttons = [];
    super.deactivate();
  }

  private function makeButtons():Array<Button> {
    return menuRecipes.map(function(recipe:MenuRecipe):Button {
      var buttonProp:ButtonProp = new ButtonProp();
      buttonProp.faChar = recipe.icon;
      var button:Button = Button.normal(recipe.text, buttonProp, function() {
        close();
        emit(new Event(ContextEvent.SCENE_CHANGE, false, recipe.route));
      });

      maxWidth = button.width > maxWidth ? button.width : maxWidth;
      buttons.push(button);

      return button;
    }).map(function(button:Button):Button {
      return button.resize(maxWidth, 0);
    });
  }

  private function get_closed():Bool {
    return state == SideMenuState.Closed;
  }

  private function get_opening():Bool {
    return state == SideMenuState.Opening;
  }

  private function get_opened():Bool {
    return state == SideMenuState.Opened;
  }

  private function get_closing():Bool {
    return state == SideMenuState.Closing;
  }
}
