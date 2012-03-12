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
	public var mobs(getMobs, null):Array<Actor>;
	
	public var index:Int;
	public var player:Actor;
	public var enemies:Array<Actor>;
	public var items:Array<Actor>;
	public var start:FlxPoint;
	public var finish:FlxPoint;
	
			
	public function new(index:Int, tiles:Array<Int>, ?w:Int = Registry.levelWidth, ?h:Int = Registry.levelHeight) {
		this.index = index;
		this.tiles = tiles;
		lightMap = [];
		visibilityMap = [];
		
		for (t in tiles) {
			lightMap.push(0);
			if(Registry.debug) {
				visibilityMap.push(IN_SIGHT);
			} else {
				visibilityMap.push(UNSEEN);
			}
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
	
	function getMobs():Array<Actor> {
		var a = [player];
		a = a.concat(enemies);
		return a;
	}
	
	function getActors():Array<Actor> {
		var a = getMobs();
		a = a.concat(items);
		return a;
	}
	
	public function isInLos(p1, p2):Bool {
		if (FlxU.getDistance(p1, p2) > Registry.fovRange) {
			return false;
		}
		
		var line = Utils.getLine(p1, p2, isBlockingSight);
		
		return line.last().intEquals(p2);
	}
	
	function updateVisibilityMap(source:FlxPoint) {
		var p1 = source;
		var p2 = new FlxPoint();
		
		// clear previous turn fov
		for(y in 0...height) {
			for (x in 0...width) {
				p2.x = x;
				p2.y = y;
				if(Utils.get(visibilityMap, width, x, y)==IN_SIGHT) {
					Utils.set(visibilityMap, width, x, y, SEEN);
				}
			}
		}
		
		var minY = Std.int(Utils.clampToRange(p1.y-Registry.fovRange,0,height));
		var maxY = Std.int(Utils.clampToRange(p1.y+Registry.fovRange+1,0,height));
		var minX = Std.int(Utils.clampToRange(p1.x-Registry.fovRange,0,width));
		var maxX = Std.int(Utils.clampToRange(p1.x+Registry.fovRange+1,0,width));
		
		// mark current fov
		for(yy in minY...maxY) {
			for (xx in minX...maxX) {
				p2.x = xx;
				p2.y = yy;
				if (isInLos(p1, p2)) {
					Utils.set(visibilityMap, width, xx, yy, IN_SIGHT);
				}
			}
		}
	}
	
	public function updateFov(source:FlxPoint) {
		updateVisibilityMap(source);
		
		var p1 = source;
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
				mapSprite.mobSprites,
				mapSprite.bulletSprites];
		
		return sprites;
	}
	
	
	public function levelOver() {
		for (sprite in sprites) {
			sprite.kill();
		}
	}
	
	public function removeEnemy(e:Actor) {
		enemies.remove(e);
		mapSprite.mobSprites.remove(e.sprite);
	}
	
	public inline function get(x:Float, y:Float):Int {
		return Utils.get(tiles,width,x,y);
	}
	public inline function set(x:Float, y:Float, val:Int) {
		Utils.set(tiles, width, x, y, val);
		mapSprite.setTile(Std.int(x), Std.int(y), val);
	}
	
	function getActorAtPoint(x:Float, y:Float):Actor {
		for (a in actors) {
			if (Std.int(a.tileX) == Std.int(x) && Std.int(a.tileY) == Std.int(y)) {
				return a;
			}
		}
		return null;
	}
	
	public function isBlockingSight(p:FlxPoint):Bool {
		return get(p.x, p.y) != 0;
	}
	
	public function isWalkable(x:Float , y:Float):Bool {
		if (x < 0 || y < 0 || x >= width || y >= height)
			return false;
	
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