package addition;
class Sizing {
    static public var scale:Float;

    static public function adjust(n:Int):Int{
        return Std.int(n * scale);
    }
}
