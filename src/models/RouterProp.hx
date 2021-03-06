package models;
import contexts.BaseContext;
import routers.Router;
class RouterProp {
  public var router:Router;
  public var contextRoot:BaseContext;

  public function new(router:Router, ?contextRoot:BaseContext, ?asRoot:Bool = false) {
    this.router = router;
    this.contextRoot = contextRoot;
  }
}
