package assets;
import flash.text.Font;

class BlockFont {
  public static var name:String;

  static public function initialize(){
    //Font.registerFont(BlockFontSrc);
    name = new BlockFontSrc().fontName;
  }
}
