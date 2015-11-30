package models.blockbreaker;
import flash.geom.Point;

class Direction {
  private var _isDownward:Bool;
  private var _isRightward:Bool;

  public function new() {
  }

  public function initialize(start:Point, end:Point) {
    this._isRightward = start.x < end.x;
    this._isDownward = start.y < end.y;
  }

  public function isDownward():Bool {
    return _isDownward;
  }

  public function isUpward():Bool {
    return !_isDownward;
  }

  public function isRightward():Bool {
    return _isRightward;
  }

  public function isLeftward():Bool {
    return !_isRightward;
  }
}
