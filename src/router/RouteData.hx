package router;

using addition.NullOr;

class RouteData {
  public var route:String;
  public var prop:Dynamic;

  public function new(route:String, prop:Dynamic = null) {
    this.route = route;
    this.prop = prop;
  }
}
