package addition;
class NullOr {
  static public function or(a:Dynamic, b:Dynamic):Dynamic {
    return a != null ? a : b;
  }

  static public function be(a:Dynamic):Bool{
    return a != null;
  }
}
