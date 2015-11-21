package addition;
class NullOr {
  static public function or(a:Dynamic, b:Dynamic):Dynamic {
    trace([a, b]);
    return a != null ? a : b;
  }

  static public function be(a:Dynamic):Bool{
    return a != null;
  }
}
