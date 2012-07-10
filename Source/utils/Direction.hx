package utils;
import org.flixel.FlxObject;

class Direction {
	static public var N = new Direction(0, -1);
	static public var E = new Direction(-1, 0);
	static public var S = new Direction(0, 1);
	static public var W = new Direction(1, 0);
	static public var wait = new Direction(0, 0);
	
	static private var compass = makeCompass();

	public var dx(default, null):Int;
	public var dy(default, null):Int;
	public var vertical(default, null):Bool;
	public var horizontal(default, null):Bool;
	public var flxFacing(default, null):Int;
	public var flip(default, null):Direction;
	
	private function new(Dx:Int, Dy:Int) {
		dx = Dx;
		dy = Dy;
		
		vertical = dx == 0 && dy != 0;
		horizontal = dy == 0 && dx != 0;
		
		if (dx == -1) flxFacing = FlxObject.LEFT;
		if (dx == 1) flxFacing = FlxObject.RIGHT;
		if (dy == -1) flxFacing = FlxObject.UP;
		if (dy == 1) flxFacing = FlxObject.DOWN;
	}
	
	private static function makeCompass():Array<Direction> {
		N.flip = S;
		S.flip = N;
		E.flip = W;
		W.flip = E;
		
		return [N, E, S, W];
	}
}
