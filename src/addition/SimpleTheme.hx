package addition;
import feathers.controls.Button;
import flash.text.TextFormat;
import feathers.controls.text.TextFieldTextRenderer;
import feathers.core.ITextRenderer;
import starling.display.Quad;
import feathers.skins.StyleNameFunctionStyleProvider;
class SimpleTheme {
  static public function button(size:Int = 14, mode:String = 'primary'):StyleNameFunctionStyleProvider {
    var colors:Array<Int> = getColorSet(mode);

    return new StyleNameFunctionStyleProvider(function(button:Button):Void {
      button.defaultSkin = new Quad( 1, 1, colors[0] );
      button.downSkin = new Quad( 1, 1, colors[1] );
      button.labelFactory = function():ITextRenderer {
        var textRenderer = new TextFieldTextRenderer();
        textRenderer.textFormat = new TextFormat( "_sans", size, 0xffffff );
        return textRenderer;
      }
      button.setSize(Math.NaN, Math.NaN);
    });
  }

  static public function getColorSet(mode:String):Array<Int> {
    switch(mode){
      case 'primary':
        return [0x2980b9, 0x3498db];
      case 'success':
        return [0x27ae60, 0x2ecc71];
      case 'information':
        return [0xf39c12, 0xf1c40f];
      case 'danger':
        return [0xc0392b, 0xe74c3c];
      default:
        return [0x7f8c8d, 0x95a5a6];
    }
  }
}


