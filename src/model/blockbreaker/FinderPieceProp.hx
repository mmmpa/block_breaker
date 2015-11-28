package model.blockbreaker;

using addition.Support;

typedef FinderPiecePropOption = {
  var type:BlockBreakerType;
  var id:String;
  @:optional var datas:Array<BlockData>;
  @:optional var thumnailPath:String;
  @:optional var blockImagePath:String;
  @:optional var backgroundPath:String;
}

class FinderPieceProp {
  public var type:BlockBreakerType;
  public var id:String;
  public var datas:Array<BlockData>;
  public var thumnailPath:String;
  public var blockImagePath:String;
  public var backgroundPath:String;

  public function new(option:FinderPiecePropOption) {
    this.deploy(option);
  }
}

