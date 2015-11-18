package model;
import flash.geom.Point;
import addition.Def;
class ShockData {
  public var x:Int;
  public var y:Int;
  public var size:Int;

  private var realX:Float;
  private var realY:Float;

  // 再利用
  static public var hitData:ShockHitData = new ShockHitData(new Point(), new Point());

  public function new(x:Int, y:Int, size:Int) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  public function hit(start:Point, end:Point):ShockHitData {
    trace(inCircle(end));
    if(inCircle(end)){
      var result:Dynamic = lineCrclCrsPt(start, end);
      ShockData.hitData.point.setTo(result.x, result.y);
      return ShockData.hitData;
    }
    return null;
  }

  public function dotProduct(ax:Float, ay:Float, bx:Float, by:Float):Float {
    return ( ax * bx ) + ( ay * by );
  }

  function inCircle(p:Point):Bool {
    var dx:Float = p.x - x;
    var dy:Float = p.y - y;
    var d:Float = Math.sqrt(dx * dx + dy * dy);

    return size >= d;
  }

  public function spread() {
    size += Def.shockPower;
  }

  public function isCompleted():Bool {
    return size > Def.shockSize;
  }

  private static var ACCY:Float = 1.0E-15;

  public function lineCrclCrsPt(start:Point, end:Point):Dynamic {
    var dx:Float = end.x - start.x;
    var dy:Float = end.y - start.y;
    var dd:Float = dx * dx + dy * dy;
    var rinv:Float = 1 / Math.sqrt(dd);
    
    var a:Float = -dy * rinv;
    var b:Float = dx * rinv;
    var c:Float = ( (start.x * end.y) - (end.x * start.y) ) * rinv;
    

    var rt:Float = 1.0 / ( (a * a) + (b * b) );
    var factor:Float = -c * rt;
    var xo:Float = a * factor;
    var yo:Float = b * factor;

    rt = Math.sqrt(rt);
    var f:Float = b * rt;
    var g:Float = -a * rt;

    var fsq:Float = f * f;
    var gsq:Float = g * g;
    var fgsq:Float = fsq + gsq;

    if (fgsq < ACCY) { return null; }

    var xjo:Float = x - xo;
    var yjo:Float = y - yo;
    var fygx:Float = (f * yjo) - (g * xjo);
    rt = ( size * size * fgsq ) - ( fygx * fygx );
    if (rt < -ACCY) { return null; }

    var fxgy:Float = (f * xjo) + (g * yjo);

    if (rt < ACCY) {
      var t:Float = fxgy / fgsq;
      return { x:( xo + (f * t) ), y:( yo + (g * t) ), n:1 };
    }

    rt = Math.sqrt(rt);
    var fginv:Float = 1.0 / fgsq;
    var t1:Float = ( fxgy - rt ) * fginv;
    var t2:Float = ( fxgy + rt ) * fginv;
    var x1:Float = xo + (f * t1);
    var y1:Float = yo + (g * t1);
    var x2:Float = xo + (f * t2);
    var y2:Float = yo + (g * t2);

    var sqdst1:Float = Math.pow((start.x - x1), 2.0) +
    Math.pow((start.y - y1), 2.0);
    var sqdst2:Float = Math.pow((start.x - x2), 2.0) +
    Math.pow((start.y - y2), 2.0);

    return ( sqdst1 < sqdst2 ) ? { x:x1, y:y1, n:2 } : { x:x2, y:y2, n:2 };
  }
}