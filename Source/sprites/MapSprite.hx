package sprites;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import world.Level;
import utils.Utils;
import data.Registry;

class MapSprite extends FlxTilemap {
	public var owner:Level;

	public var itemSprites:FlxGroup;
	public var actorSprites:FlxGroup;

	public function findTilePath(start:FlxPoint, end:FlxPoint):FlxPath {
		var s = new FlxPoint(start.x*_tileWidth, start.y*_tileHeight);
		var e = new FlxPoint(end.x*_tileWidth, end.y*_tileHeight);
		
		return findPath(s, e, false);
	}
	
	public function new(owner:Level) {
		super();
		this.owner = owner;
		
		loadMap(FlxTilemap.arrayToCSV(owner.tiles, Registry.levelWidth), FlxTilemap.imgAuto, 0, 0, FlxTilemap.AUTO);
	}
	
	public function addAllActors() {
		actorSprites = new FlxGroup();
		itemSprites = new FlxGroup();
		for (a in owner.actors) {
			if(Utils.contains(owner.items,a)) {
				itemSprites.add(a.sprite);
			} else {
				actorSprites.add(a.sprite);
			}
		}
	}
	
	override public function update() {
		super.update();
		
		// physics stuff
		FlxG.collide(this, actorSprites);
		FlxG.collide(this, itemSprites);
		FlxG.collide(actorSprites, actorSprites);
		FlxG.overlap(actorSprites, itemSprites, overlap);
	}
	
	public function overlap(a:ActorSprite, i:ActorSprite) {
		switch (i.owner.type) 
		{
			case LEVER_CLOSE:
				// fixme: switch to open lever & open door
				a.owner.items.push(i.owner);
				itemSprites.remove(i);
				
			case DOOR_CLOSE:
/*				a.x = i.x - Registry.tileSize;
				if (a.owner.has(KEY)) {
					a.owner.remove(KEY);
					itemSprites.remove(i);
				} else {*/
					FlxG.collide(a, i);
				//}
				
			default:
				
		}
		
	}
}