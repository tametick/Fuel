package world;

import org.flixel.FlxPoint;
import org.flixel.FlxU;
import sprites.MapSprite;
import data.Registry;
import data.Library;
import utils.Utils;

class Level {	
	public var mapSprite:MapSprite;
	public var tiles:Array<Int>;
	public var visibilityMap:Array<Visibility>;
	public var lightMap:Array<Float>;
	public var width:Int;
	public var height:Int;
	
	public var sprites(getSprites, null):Array<Dynamic>;
	public var actors(getActors, null):Array<Actor>;
	
	public var player:Actor;
	public var enemies:Array<Actor>;
	public var items:Array<Actor>;
	public var start:FlxPoint;
	public var finish:FlxPoint;
			
	public function new(tiles:Array<Int>, ?w:Int = Registry.levelWidth, ?h:Int = Registry.levelHeight) {
		this.tiles = tiles;
		lightMap = [];
		visibilityMap = [];
		for (t in tiles) {
			lightMap.push(0);
			visibilityMap.push(UNSEEN);
		}
		width = w;
		height = h;
		
		enemies = [];
		items = [];
		start = new FlxPoint();
		finish = new FlxPoint();
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
	
	public function isInLos(p1, p2):Bool {
		if (FlxU.getDistance(p1, p2) > Registry.fovRange) {
			return false;
		}
		
		var line = Utils.getLine(p1, p2, isBlockingSight);
		
		return line[line.length - 1].equals(p2);
	}
	
	function updateVisibilityMap() {
		// naive fov
		
		var p1 = Registry.player.tilePoint;
		var p2 = new FlxPoint();
		for(y in 0...height) {
			for (x in 0...width) {
				p2.x = x;
				p2.y = y;
				if(Utils.get(visibilityMap, width, x, y)==IN_SIGHT)
					Utils.set(visibilityMap, width, x, y, SEEN);
				if (isInLos(p1, p2))
					Utils.set(visibilityMap, width, x, y, IN_SIGHT);
			}
		}
			
	}
	
	public function updateFov() {
		updateVisibilityMap();
		
		var p1 = Registry.player.tilePoint;
		var p2 = new FlxPoint();
		for(y in 0...height) {
			for (x in 0...width) {
				p2.x = x;
				p2.y = y;
				var l;
				switch(Utils.get(visibilityMap, width, x, y)) {
					case IN_SIGHT:
						var d = FlxU.getDistance(p1, p2);
						l = Math.min(1, d / Registry.fovRange) * 0.8;
					case SEEN:
						l = 0.8;
					case UNSEEN:
						l = 1;
				}
				Utils.set(lightMap, width, x, y, l);
			}
		}
		
		mapSprite.drawFov(lightMap);
	}
	
	function getSprites():Array<Dynamic> {
		var sprites = [mapSprite, 
				mapSprite.itemSprites,
				mapSprite.actorSprites,
				mapSprite.bulletSpritesAsSingleGroup,
				Registry.player.sprite.directionIndicator];
		
		return sprites;
	}
	
	public inline function get(x:Int, y:Int):Int {
		return Utils.get(tiles,width,x,y);
	}
	public inline function set(x:Int, y:Int, val:Int) {
		Utils.set(tiles, width, x, y, val);
		mapSprite.setTile(x, y, val);
	}
	
	function getActorAtPoint(x:Int, y:Int):Actor {
		for (a in actors) {
			if (Std.int(a.tileX) == x && Std.int(a.tileY) == y) {
				return a;
			}
		}
		return null;
	}
	
	public function isBlockingSight(p:FlxPoint):Bool {
		return get(Std.int(p.x), Std.int(p.y)) != 0;
	}
	
	public function isWalkable(x:Int , y:Int):Bool {
		var a = getActorAtPoint(x, y);
		return get(x, y) == 0 && (a==null || !a.isBlocking);
	}
	
	public function getFreeTile():FlxPoint {
		var ex, ey:Int;
		var p:FlxPoint = new FlxPoint();
		
		do {
			p.x = ex = Utils.randomIntInRange(1,width-2);
			p.y = ey = Utils.randomIntInRange(1,height-2);
		} while (getActorAtPoint(ex, ey)!=null || !isWalkable(ex, ey));
		
		return p;
	}	
}

enum Visibility {
	UNSEEN;
	SEEN;
	IN_SIGHT;
}