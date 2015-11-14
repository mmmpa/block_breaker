package;
import addition.Sizing;
import flash.system.Capabilities;
import haxe.Json;
import flash.Lib;
import flash.display.Sprite;

using addition.Sizing;
@:meta(SWF(width = '400', height = '800', backgroundColor = '#ffffff', frameRate = '60'))

class Main extends Sprite {
    static public function main():Void {
        init();
        test();
        Game.start(Lib.current.stage);
    }

    static public function test():Void {
        trace(Json.stringify({
            test:"test"
        }));
    }

    static public function init():Void {
        initTrace();
        initScale();
    }

    static public function initScale():Void {
        var target_dpi:Float = Capabilities.screenDPI;
        var base_dpi:Float = 72;
        Sizing.scale = target_dpi / base_dpi;
    }

    static public function initTrace():Void {
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


