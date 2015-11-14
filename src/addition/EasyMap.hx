package addition;
import flash.utils.Function;
using Lambda;
using addition.EasyMap;
class EasyMap {
    static public function keys(d:Dynamic):Array<String> {
        return Reflect.fields(d);
    }

    static public function eachKey(d:Dynamic, f:Function) {
        d.keys().map(function(key:String) {
            f(key, untyped {d[key];});
        });
    }
}
