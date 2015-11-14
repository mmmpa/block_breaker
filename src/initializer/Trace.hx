package initializer;
class Trace {
  static public function initialize():Void {
#if (flash9 || flash10)
    haxe.Log.trace = function(v, ?pos) {
      untyped __global__["trace"](pos.className + "#" + pos.methodName + "(" + pos.lineNumber + "):", v);
    }
#elseif flash
    haxe.Log.trace = function(v, ?pos) {
      flash.Lib.trace(pos.className + "#" + pos.methodName + "(" + pos.lineNumber + "): " + v);
    }
#end
  }
}
