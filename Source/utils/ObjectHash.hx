package utils;

#if flash
import flash.utils.Dictionary;
#end
	
class ObjectHash <T> {
	#if flash
	private var dictionary:Dictionary;
	#else
	private var hash:IntHash <T>;
	#end

	public function new () {
		#if flash
		dictionary = new Dictionary (true);
		#else
		hash = new IntHash <T> ();
		#end
	}

	public inline function exists (key:Dynamic):Bool {
		#if flash
		return untyped dictionary[key] != null;
		#else
		return hash.exists (getID (key));
		#end
	}

	public inline function get (key:Dynamic):T {
		#if flash
		return untyped dictionary[key];
		#else
		return hash.get (getID (key));
		#end
	}

	private inline function getID (key:Dynamic):Int {
		#if cpp
		return untyped __global__.__hxcpp_obj_id (key);
		#else
		return 0;
		#end
	}

	public inline function iterator ():Iterator <T> {
		#if flash
		return untyped __keys__(dictionary);
		#else
		return hash.iterator ();
		#end
	}

	public inline function remove (key:Dynamic):Void {
		#if flash
		untyped dictionary[key] = null;
		#else
		hash.remove (getID (key));
		#end
	}

	public inline function set (key:Dynamic, value:T):Void {
		#if flash
		untyped dictionary[key] = value;
		#else
		hash.set (getID (key), value);
		#end
	}

}