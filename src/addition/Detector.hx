package addition;
class Detector {
    public static function or(target:Dynamic, substitute:Dynamic):Dynamic{
        if(target != null){
            return target;
        }
        return substitute;
    }
}
