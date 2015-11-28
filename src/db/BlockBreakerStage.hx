package db;
import model.blockbreaker.BlockBreakerType;
import model.blockbreaker.FinderProp;
class BlockBreakerStage {
  static public var all:FinderProp = new FinderProp([
    {
      type: BlockBreakerType.Image,
      id: 'crash',
      thumnailPath: 'asset/crash_thum.png',
      blockImagePath: 'asset/crash.png'
    }, {
      type: BlockBreakerType.Image,
      id: 'kobito',
      thumnailPath: 'asset/kobito_thum.png',
      blockImagePath: 'asset/kobito.png'
    }, {
      type: BlockBreakerType.Image,
      id: 'octcat',
      thumnailPath: 'asset/octcat_thum.png',
      blockImagePath: 'asset/octcat.png'
    }
  ]);
}
