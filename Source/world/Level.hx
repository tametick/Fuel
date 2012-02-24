package world;

import org.flixel.FlxPoint;
import sprites.MapSprite;
import data.Registry;
import data.Library;
import utils.Utils;

class Level {	
	public var mapSprite:MapSprite;
	public var tiles:Array<Int>;
	public var lightMap:Array<Int>;
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
		for (t in tiles) {
			lightMap.push(0);
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
	
	public function updateFov() {
		// todo
		
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