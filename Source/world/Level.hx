package world;

import nme.display.BitmapData;
import org.flixel.FlxPoint;
import sprites.MapSprite;
import data.Registry;
import data.Library;
import utils.Utils;

class Level {	
	public var mapSprite:MapSprite;
	public var tiles:Array<Int>;
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