package utils;

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
}