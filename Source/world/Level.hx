package world;

import nme.display.BitmapData;
import data.Registry;
import data.Library;
import org.flixel.FlxPoint;
import utils.Utils;
import sprites.MapSprite;

class Level {	
	public var mapSprite:MapSprite;
	public var tiles:Array<Int>;
	public var width:Int;
	public var height:Int;
	
	public var actors(getActors, null):Array<Actor>;

	// Actors are just ints used to lookup in the parts list,
	// all the actual logic is in actor parts.
	public var nextActor:Int;
	public var parts:IntHash<IntHash<Part>>;
  
	public var player:Actor;
	public var enemies:Array<Actor>;
	public var items:Array<Actor>;
	public var start:FlxPoint;
	public var finish:FlxPoint;
	
			
	public function new(tiles:Array<Int>, ?w:Int = Registry.levelWidth, ?h:Int = Registry.levelHeight) {
		this.tiles = tiles;
		width = w;
		height = h;
		
		enemies = [];
		items = [];
		start = new FlxPoint();
		finish = new FlxPoint();
		parts = new IntHash<IntHash<Part>>();
	}
	
	public function init() {
		mapSprite = new MapSprite(this);
	}
	
	function getActors():Array<Actor> {
		var a = [player];
		a = a.concat(enemies);
		a = a.concat(items);
		return a;
	}
	
	function newActor():Int {
		var result = nextActor;
		nextActor++;
		parts.set(result, new IntHash<Part>());
		return result;
	}

	inline function getParts(actor:Int):IntHash<Part> {
		var result = parts.get(actor);
		if (result == null) throw "Actor not found";
		return result;
	}

	function actorAs(actor:Int, kind:Kind) {
		return getParts(actor).get(Type.enumIndex(kind));
	}

	function addPart(actor:Int, part:Part) {
		getParts(actor).set(Type.enumIndex(part.getKind()), part);
	}

	function deleteActor(actor:Int) {
		// TODO: Notify components of removal
		parts.remove(actor);
	}

	public inline function get(x:Int, y:Int):Int {
		return Utils.get(tiles,width,x,y);
	}
	public inline function set(x:Int, y:Int, val:Int) {
		Utils.set(tiles, width, x, y, val);
	}
	
	function existActorAtPoint(x:Int, y:Int):Bool {
		for (a in actors) {
			if (Std.int(a.tileX) == x && Std.int(a.tileY) == y) {
				return true;
			}
		}
		return false;
	}
	
	function isWalkableTile(x:Int , y:Int):Bool {
		return get(x, y) == 0;
	}
	
	public function getFreeTile():FlxPoint {
		var ex, ey:Int;
		var p:FlxPoint = new FlxPoint();
		
		do {
			p.x = ex = Utils.randomIntInRange(1,width-2);
			p.y = ey = Utils.randomIntInRange(1,height-2);
		} while (existActorAtPoint(ex, ey) || !isWalkableTile(ex, ey));
		
		return p;
	}
	
}