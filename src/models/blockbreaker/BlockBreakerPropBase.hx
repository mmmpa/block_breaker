package models.blockbreaker;
class BlockBreakerPropBase {
  public var id:String;

  public function new(id:Dynamic) {
    this.id = Std.string(id);
  }
}
