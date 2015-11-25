package model.blockbreaker;
import flash.geom.Point;
import config.Def;
 class ShockData {
  public static var nextId = 0;

  public var id:Int;
  public var x:Int;
  public var y:Int;
  public var size:Int;

  private var realX:Float;
  private var realY:Float;

  // 再利用
  static public var hitData:ShockHitData = new ShockHitData(new Point(), new Point());

  static public function generateId():Int {
    nextId++;
    return nextId;
  }

  public function new(x:Int, y:Int, size:Int) {
    this.id = generateId();
    this.x = x;
    this.y = y;
    this.size = size;

    ShockData.hitData.id = id;
  }

  public function hit(start:Point, end:Point):ShockHitData {
    // 円内に入り込んでいるので別処理
    if (inCircle(end) && inCircle(start)) { return hitInCircle(end); }

    var result:Dynamic = cross(start, end);

    // 円と線分の接触なし
    if (result == null) { return null; }

    var hit:Point = ShockData.hitData.point;
    hit.setTo(result.x, result.y);
    ShockData.hitData.radian = nextRadian(start, end, hit);
    var rest:Float = distance(start.x, start.y, end.x, end.y) - distance(start.x, start.y, hit.x, hit.y);

    // 終点より接触点が遠い
    if (rest < 0) { return null; }

    var nextX = hit.x + Math.cos(ShockData.hitData.radian) * rest;
    var nextY = hit.y + Math.sin(ShockData.hitData.radian) * rest;
    ShockData.hitData.next.setTo(nextX, nextY);
    return ShockData.hitData;
  }

  private function nextRadian(start:Point, end:Point, hit:Point):Float {
    var lineD:Float = radianToDegree(radian(end.x, end.y, start.x, start.y));
    var centerD:Float = radianToDegree(radian(hit.x, hit.y, x, y));
    if (inCircle(start)) {
      return degreeToRadian(centerD + (centerD - lineD) + 180);
    }
    return degreeToRadian(centerD + (centerD - lineD));
  }


  public function hitInCircle(p:Point) {
    var r:Float = radian(x, y, p.x, p.y);
    var p:Point = pointOnCircle(r, ShockData.hitData.point);
    ShockData.hitData.next.setTo(p.x, p.y);
    ShockData.hitData.radian = r;
    ShockData.hitData.id = id;
    return ShockData.hitData;
  }

  private function pointOnCircle(radian:Float, setPoint:Point):Point {
    setPoint.setTo(x + Math.cos(radian) * size, y + Math.sin(radian) * size);
    return setPoint;
  }

  private function distance(ax:Float, ay:Float, bx:Float, by:Float):Float {
    var dx:Float = bx - ax;
    var dy:Float = by - ay;
    return Math.sqrt(dx * dx + dy * dy);
  }

  private function radianToDegree(n:Float) {
    return n * 180 / Math.PI;
  }

  private function degreeToRadian(n:Float) {
    return n * Math.PI / 180;
  }

  private function radian(ax:Float, ay:Float, bx:Float, by:Float):Float {
    return Math.atan2(by - ay, bx - ax);
  }

  private function inCircle(p:Point):Bool {
    return size >= distance(x, y, p.x, p.y);
  }

  public function spread() {
    size += Std.int((Def.shockSize - size) * Def.shockPower) + 1;
  }

  public function isCompleted():Bool {
    return size > Def.shockSize;
  }

  // 参考 : http://www.dango-itimi.com/blog/swf/32/Equation.as

  private static var ACCY:Float = 1.0E-15;

  public function cross(start:Point, end:Point):Dynamic {
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