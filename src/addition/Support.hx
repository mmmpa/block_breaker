package addition;
class Support {
  static public function or(a:Dynamic, b:Dynamic):Dynamic {
    return a != null ? a : b;
  }

  static public function be(a:Dynamic):Bool {
    return a != null;
  }

  static public function fit(a:Dynamic, b:Dynamic) {
    a.width = b.width;
    a.height = b.height;

    return a;
  }

  static public function shape(a:Dynamic, w:Float, h:Float) {
    a.width = Std.int(w);
    a.height = Std.int(h);

    return a;
  }

  static public function posit(a:Dynamic, x:Float, y:Float) {
    a.x = Std.int(x);
    a.y = Std.int(y);

    return a;
  }
}
