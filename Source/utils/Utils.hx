package utils;
import org.flixel.FlxPoint;

class Utils {
	public static function contains<T>(a:Array<T>, i:T):Bool {
		for (item in a) {
			if (item == i) {
				return true;
			}
		}
		return false;
	}
	
	public static function next<T>(a:Array<T>, i:T):T {
		for (index in 0...a.length) {
			if (a[index] == i) {
				if (index == a.length-1) {
					return a[0];
				} else {
					return a[index+1];
				}
			}
		}
		return null;
	}
	
	public static function allExcept<T>(a:Array<T>, i:T):Array<T> {
		var aa = a.copy();
		aa.remove(i);
		return aa;
	}
	
	inline public static function get<T>(map:Array<T>, width:Int, x:Int, y:Int):T {
		return map[y * width + x];
	}
	inline public static function set<T>(map:Array<T>, width:Int, x:Int, y:Int, val:T) {
		map[y * width + x] = val;
	}
	
	public static function randomInt(max:Int):Int {
		return Math.floor(Math.random() * max);
	}
	
	public static function randomIntInRange(min:Int, max:Int):Int {
		return Math.round(Math.random() * (max-min))+min;
	}
	
	public static function clampToRange(i:Float, min:Float, max:Float):Float {
		if (i < min)
			return min;
		if (i > max)
			return max;
		return i;
	}
	
	static var line:Array<FlxPoint> = new Array(); 
	public static function getLine(src:FlxPoint, dest:FlxPoint, isBlocking:FlxPoint->Bool):Array<FlxPoint> {
		line.splice(0, line.length);
		var steepness = (dest.x - src.x) / (dest.y - src.y);
		var x = src.x;
		var y = src.y;
		var pos:FlxPoint;
		if (Math.abs(steepness) < 1) {
			
			if(dest.y>y){
				while (y < dest.y + 1) {
					pos = new FlxPoint(x, y);
					line.push(pos);
					pos = null;
					if (isBlocking(line[line.length - 1]))
						break;
					x += steepness;
					y++;
				}
			} else {
				while (y > dest.y-1) {
					pos = new FlxPoint(x, y);
					line.push(pos);
					pos = null;
					if (isBlocking(line[line.length - 1]))
						break;
					x -= steepness;
					y--;
				}
			}
		} else {
			steepness = 1 / steepness;
			if(dest.x>x){
				while (x < dest.x + 1) {
					pos = new FlxPoint(x, y);
					line.push(pos);
					pos = null;
					if (isBlocking(line[line.length - 1]))
						break;
					y += steepness;
					x++;
				}
			} else {
				while (x > dest.x - 1) {
					pos = new FlxPoint(x, y);
					line.push(pos);
					pos = null;
					if (isBlocking(line[line.length - 1]))
						break;
					y -= steepness;
					x--;
				}
			}
		}
		
		pos = null;
		isBlocking = null;
		
		return line;
	}
}