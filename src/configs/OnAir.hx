package configs;
class OnAir {
  // air側から有効にする
  static public var enable:Bool = false;

  // airをコールする
  // 処理はairから注入される
  static public var exit:Dynamic;

  // airからのコールされる
  static public var back:Dynamic = function(e:Dynamic) {};
  static public var home:Dynamic = function(e:Dynamic) {};
  static public var invoke:Dynamic = function(e:Dynamic) {};
  static public var activate:Dynamic = function(e:Dynamic) {};
  static public var deactivate:Dynamic = function(e:Dynamic) {};
}

