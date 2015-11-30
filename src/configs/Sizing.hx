package configs;
class Sizing {
  static public var scale:Float;
  static public var dpi:Float;
  static public var dpmm:Float;

  static public function adjust(n:Int):Int {
    return Std.int(n * scale);
  }

  static public function mm(n:Int):Int{
    return Std.int(n * dpmm);
  }
}
