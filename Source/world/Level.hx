package world;

import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxU;
import sprites.MapSprite;
import data.Registry;
import data.Library;
import utils.Direction;
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
	public var exit:FlxPoint;
	
	public var entryDoor:Actor;
	public var exitDoor:Actor;
	
			
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
		exit = new FlxPoint();
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
	
	public function isInLos(p1, p2, ?dist=Registry.fovRange):Bool {
		if (FlxU.getDistance(p1, p2) > dist) {
			return false;
		}
		
		var line = Utils.getLine(p1, p2, isBlockingSight);
		var last:FlxPoint = line.last();
		
		return Std.int(last.x) == Std.int(p2.x) && Std.int(last.y) == Std.int(p2.y);
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
						l = Math.min(1, d / Registry.fovRange) * 0.7;
					case SEEN:
						l = 0.7;
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
			if(sprite!=mapSprite.bulletSprites) {
				sprite.kill();
			}
		}
	}
	
	public function removeActor(e:Actor) {
		if(Utils.exists(enemies, e)) {
			enemies.remove(e);
			mapSprite.mobSprites.remove(e.sprite);
		} else if(Utils.exists(items, e)) {
			items.remove(e);
			mapSprite.itemSprites.remove(e.sprite);
		} else if (e == Registry.player) {
			// todo?
		}
		
		e.sprite.kill();
	}
	
	public inline function get(x:Float, y:Float):Int {
		return Utils.get(tiles,width,x,y);
	}
	public inline function set(x:Float, y:Float, val:Int) {
		Utils.set(tiles, width, x, y, val);
		mapSprite.setTile(Std.int(x), Std.int(y), val);
	}
	
	public function getActorAtPoint(x:Float, y:Float):Array<Actor> {
		var actorsAtPoint = [];
		if (!inBounds(x, y))
			return actorsAtPoint;
	
		for (a in actors) {
			if (Std.int(a.tileX) == Std.int(x) && Std.int(a.tileY) == Std.int(y)) {
				actorsAtPoint.push(a);
			}
		}
		return actorsAtPoint;
	}
	
	public function isBlockingSight(p:FlxPoint):Bool {
		return get(p.x, p.y) != 0;
	}
	
	function inBounds(x:Float , y:Float):Bool {
		return  !(x < 0 || y < 0 || x >= width || y >= height);
	}
	
	public function isWalkable(x:Float , y:Float):Bool {
		if (!inBounds(x,y))
			return false;
	
		var blocking = false;
		for (a in getActorAtPoint(x, y)) {
			if (a.isBlocking)
				blocking = true;
		}
		
		return get(x, y) == 0 && !blocking;
	}
	
	public function getFreeTile():FlxPoint {
		var ex, ey:Int;
		var p:FlxPoint = new FlxPoint();
		
		do {
			p.x = ex = Utils.randomIntInRange(1,width-2);
			p.y = ey = Utils.randomIntInRange(1,height-2);
		} while (getActorAtPoint(ex, ey).length>0 || !isWalkable(ex, ey));
		
		return p;
	}
	
	/** isOnFloor determines if it's on the floor or on the ceiling  */
	public function getFreeTileOnWall(?isOnFloor:Bool= true):FlxPoint {
		var t:FlxPoint = null;
		do {
			if(isOnFloor) {
				t = goDownTillFloor(getFreeTile());
			} else {
				t = goUpTillCeiling(getFreeTile());
			}
		} while (getActorAtPoint(t.x, t.y).length>0);
		return t;
	}
	
	public function goDownTillFloor(t:FlxPoint):FlxPoint {
		while(inBounds(t.x,t.y+1) && get(t.x, t.y + 1)==0) {
			t.y++;
		}
		return t;
	}
	public function goUpTillCeiling(t:FlxPoint):FlxPoint {
		while(inBounds(t.x,t.y-1) && get(t.x, t.y-1)==0) {
			t.y--;
		}
		return t;
	}
	
	
	public function getFreeNeighbors(p:FlxPoint):Array<Direction> {
		var n = [];
		if (isWalkable(p.x - 1, p.y)) n.push(Direction.W);
		if (isWalkable(p.x + 1, p.y)) n.push(Direction.E);
		if (isWalkable(p.x, p.y-1)) n.push(Direction.N);
		if (isWalkable(p.x, p.y+1)) n.push(Direction.S);
		return n;
	}
	
	public function passTurn() {
		for (e in enemies) {
			e.act();
		}
		
		Registry.player.stats.suitCharge -= Registry.suitChargeRate;
		if (Registry.player.stats.suitCharge < 0.01) {
			Registry.player.kill();
		}
	}
	
	public function addIceCrystal(x:Float, y:Float) {
		var ice = ActorFactory.newActor(ICE, x, y);
		
		mapSprite.addItemAndSprite(ice);
	}
}

enum Visibility {
	UNSEEN;
	SEEN;
	IN_SIGHT;
}