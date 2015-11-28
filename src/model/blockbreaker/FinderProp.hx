package model.blockbreaker;
class FinderProp {
  public var games:Array<BlockBreakerRouteProp>;

  public function new(games:Array<BlockBreakerRouteProp>) {
    this.games = games;
  }
}

typedef BlockBreakerRouteProp = {
  type: BlockBreakerType,
  id: String,
  ?datas: Array<BlockData>,
  ?blockImagePath: String,
  ?backgroundPath: String
}