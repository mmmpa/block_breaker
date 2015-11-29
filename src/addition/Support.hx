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

  static public function center(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.x = Std.int(b.width - a.width) >> 1;
    a.x += Std.int(offset);

    return a;
  }

  static public function top(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.y = b.y;
    a.y += Std.int(offset);

    return a;
  }

  static public function middle(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.y = Std.int(b.y) + Std.int(b.height - a.height) >> 1;
    a.y += Std.int(offset);

    return a;
  }

  static public function bottom(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.y = Std.int(b.y + b.height - a.height);
    a.y += Std.int(offset);

    return a;
  }

  static public function bottomLine(a:Dynamic, offset:Float = 0) {
    return Std.int(a.y + a.height + offset);
  }


  static public function under(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.y = Std.int(b.y + b.height);
    a.y += Std.int(offset);

    return a;
  }

  static public function over(a:Dynamic, b:Dynamic, offset:Float = 0) {
    a.y = Std.int(b.y - a.height);
    a.y += Std.int(offset);

    return a;
  }

  static public function deploy(a:Dynamic, b:Dynamic, defaultValue:Dynamic = null, only:Array<String> = null) {
    if (defaultValue != null) {deploy(a, defaultValue);}
    if (b == null) { return; }

    var onlied:Bool = only != null;
    var keys:Array<String> = onlied ? only : Reflect.fields(b);
    for (key in keys) {
      if (onlied && !Reflect.hasField(b, key)) { continue; }
      untyped{ a[key] = b[key]; }
    }
  }
}
