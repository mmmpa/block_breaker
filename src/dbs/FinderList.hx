package dbs;
import models.blockbreaker.FinderProp;
import models.blockbreaker.FinderPieceProp;
import models.blockbreaker.BlockBreakerType;

class FinderList {
  static public var all:FinderProp = (function() {
    var pieces:Array<FinderPieceProp> = [
      new FinderPieceProp({
        type: BlockBreakerType.Image,
        id: 'crash',
        thumnailPath: 'asset/crash_thum.png',
        blockImagePath: 'asset/crash.png'
      }),
      new FinderPieceProp({
        type: BlockBreakerType.Image,
        id: 'kobito',
        thumnailPath: 'asset/kobito_thum.png',
        blockImagePath: 'asset/kobito.png'
      }),
      new FinderPieceProp({
        type: BlockBreakerType.Image,
        id: 'octcat',
        thumnailPath: 'asset/octcat_thum.png',
        blockImagePath: 'asset/octcat.png'
      })
    ];

    return new FinderProp(pieces);
  })();
}
