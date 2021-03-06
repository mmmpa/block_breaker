package routers;

using additions.Support;

class SceneChangeData {
  public var route:String;
  public var prop:Dynamic;
  public var forceReload:Bool;

  public function new(route:String, prop:Dynamic = null, forceReload:Bool = false) {
    this.route = route;
    this.prop = prop;
    this.forceReload = forceReload;
  }
}
