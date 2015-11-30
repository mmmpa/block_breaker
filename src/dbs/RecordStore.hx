package dbs;
import flash.net.SharedObject;
class RecordStore {
  static public var so:SharedObject = (function() {
    var so:SharedObject = SharedObject.getLocal("bb_bestscore");
    if (so.data.records == null) {
      so.data.records = {};
    }
    return so;
  })();

  static public function write(id:Dynamic, record:Record) {
    untyped { so.data.records[Std.string(id)] = record;}
  }

  static public function read(id:Dynamic):Record {
    trace('read');
    untyped { return so.data.records[Std.string(id)]; }
  }
}

typedef Record = { score:Int, time:Float}
