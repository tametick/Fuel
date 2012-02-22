package sprites;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import world.Actor;
import world.ActorFactory;
import world.Level;
import utils.Utils;
import data.Registry;

class MapSprite extends FlxTilemap {
	public var owner:Level;

	public var itemSprites:FlxGroup;
	public var actorSprites:FlxGroup;
	public var bulletSprites(getBulletSprites, null):Array<FlxGroup>;
	public var bulletSpritesAsSingleGroup(getBulletSpritesAsSingleGroup, null):FlxGroup;
	
	public var exitDoorSprite:ActorSprite;

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
	
		
	function getBulletSprites():Array<FlxGroup> {
		// only calculated when creating new level
		if (bulletSprites != null) {
			return bulletSprites;
		}
		
		var bulletSprites = [];
		for (a in owner.actors) {
			if (a.weapon != null) {
				bulletSprites.push(a.weapon.group);
			}
		}
		return bulletSprites;
	}
	
	function getBulletSpritesAsSingleGroup():FlxGroup {
		// only calculated when creating new level
		if (bulletSpritesAsSingleGroup != null) {
			return bulletSpritesAsSingleGroup;
		}
		
		bulletSpritesAsSingleGroup = new FlxGroup();
		for (bullets in getBulletSprites()) {
			for (bullet in bullets.members) {
				bulletSpritesAsSingleGroup.add(bullet);
			}
		}
		
		return bulletSpritesAsSingleGroup;
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
	
	public function addEnemyAndSprite(e:Actor) {
		owner.enemies.push(e);
		actorSprites.add(e.sprite);
	}
	
	public function addItemAndSprite(i:Actor) {
		owner.items.push(i);
		itemSprites.add(i.sprite);
	}
	
	override public function update() {
		super.update();
		
		// physics stuff
		FlxG.collide(this, actorSprites);
		FlxG.collide(this, bulletSpritesAsSingleGroup, hitWall);
		FlxG.collide(this, itemSprites);
		FlxG.collide(actorSprites, actorSprites);
		FlxG.overlap(actorSprites, itemSprites, overlap);
		
		for (actor in actorSprites.members) {
			var a = cast(actor, ActorSprite);
			var w = a.owner.weapon;
			if (w != null) {
				var groupOfOthers = new FlxGroup();
				groupOfOthers.members = Utils.allExcept(actorSprites.members, a);
				FlxG.collide(groupOfOthers, w.group, hitActor);
			}
		}
	}
	
	public function hitWall(m:MapSprite, i:Bullet) {
		var e = cast(i.weapon.parent, ActorSprite).explosionEmitter;
		Registry.gameState.add(e);
		e.x = i.x;
		e.y = i.y;
		for(p in 0...e.maxSize) {
			e.emitParticle();
		}
		i.kill();
	}
	
	public function hitActor(a:ActorSprite, i:Bullet) {
		trace(a, i);
	}
	
	public function overlap(a:ActorSprite, i:ActorSprite) {
		switch (i.owner.type) {
			case LEVER_CLOSE:
				// switch lever
				itemSprites.remove(i);
				owner.items.remove(i.owner);
				var openLever = ActorFactory.newActor(LEVER_OPEN, i.owner.tileX, i.owner.tileY);
				addItemAndSprite(openLever);
				
				// open exit door
				itemSprites.remove(exitDoorSprite);
				owner.items.remove(exitDoorSprite.owner);
				var openDoor = ActorFactory.newActor(DOOR_OPEN, exitDoorSprite.owner.tileX, exitDoorSprite.owner.tileY);
				addItemAndSprite(openDoor);
				
				
			case DOOR_CLOSE:
				if(i.x>a.x) {
					a.x = i.x - Registry.tileSize - 1;
				} else {
					a.x = i.x + Registry.tileSize + 1;
				}
			
			case DOOR_OPEN:
				// this should probably be repalced with STAIRS or something
				Registry.gameState.newLevel();
				
			default:
				
		}
		
	}
}