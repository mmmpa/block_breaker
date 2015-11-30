package models.blockbreaker;
class BlockBreakerProp extends BlockBreakerPropBase{
  public var grid:BlockGrid;

  public function new(id:Dynamic, grid:BlockGrid) {
    super(id);
    this.grid = grid;
  }
}
