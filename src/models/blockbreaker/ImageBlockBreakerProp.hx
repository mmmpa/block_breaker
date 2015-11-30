package models.blockbreaker;
class ImageBlockBreakerProp extends BlockBreakerPropBase {
  public var path:String;

  public function new(id:Dynamic, path:String) {
    super(id);
    this.path = path;
  }
}
