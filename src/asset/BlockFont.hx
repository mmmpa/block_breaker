package asset;
import flash.text.Font;
@:font("../lib/font/CheapProFonts - KremlinPro.ttf") class BlockFont extends Font {
  public static var name:String = (function() {
    Font.registerFont(BlockFont);
    return new BlockFont().fontName;
  })();
}
