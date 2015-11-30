package models.blockbreaker;
class BlockBreakerPlayingState {
  public var newBalls:Array<BallData> = new Array();
  public var state:BlockBreakerState = BlockBreakerState.Ready;
  public var blockBroken:Bool = false;
  public var blockHitted:Bool = false;

  public function new() {
  }
}
