package sprites;

import com.eclecticdesignstudio.motion.Actuate;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxTilemap;
import org.flixel.plugin.photonstorm.baseTypes.Bullet;
import data.Registry;
import utils.Utils;
import states.GameState;
import world.Actor;
import world.ActorFactory;
import world.Level;


class MapSprite extends FlxTilemap {
	public var owner:Level;

	public var itemSprites:FlxGroup;
	public var mobSprites:FlxGroup;
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
		updateTileSheet();
	}
		
	public function drawFov(lightMap:Array<Float>) {
		for(y in 0...heightInTiles) {
			for (x in 0...widthInTiles) {
				var normalizedDarkness = Utils.get(lightMap, widthInTiles, x, y);
				
				var oldDarkness = GameState.lightingLayer.getDarknessAtTile(x, y);
				var newDarkness = Std.int(normalizedDarkness * 0xff);
				
				var setDarkness = function (d:Int) {
					GameState.lightingLayer.setDarknessAtTile(x, y, d);
				}
				
				if(oldDarkness != newDarkness) {
					var walkingSpeed = Registry.player.stats.walkingSpeed;
					Actuate.update(setDarkness, 1/(walkingSpeed), [oldDarkness], [newDarkness]);
				}
			}
		}
	}
		
	function getBulletSprites():Array<FlxGroup> {
		// only calculated when creating new level
		if (bulletSprites != null) {
			return bulletSprites;
		}
		
		var bulletSprites = [];
		for (a in owner.actors) {
			if (a.weapon != null) {
				bulletSprites.push(a.weapon.sprite.group);
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
		mobSprites = new FlxGroup();
		itemSprites = new FlxGroup();
		for (a in owner.actors) {
			if(Utils.exists(owner.items,a)) {
				itemSprites.add(a.sprite);
			} else {
				mobSprites.add(a.sprite);
			}
		}
	}
	
	public function addEnemyAndSprite(e:Actor) {
		owner.enemies.push(e);
		mobSprites.add(e.sprite);
	}
	
	public function addItemAndSprite(i:Actor) {
		owner.items.push(i);
		itemSprites.add(i.sprite);
	}
	
	override public function update() {
		super.update();
		
		FlxG.collide(this, bulletSpritesAsSingleGroup, hitWall);
		FlxG.collide(mobSprites, mobSprites);
				
		for (actor in mobSprites.members) {
			if (actor == null)
				continue;
			
			var a = cast(actor, ActorSprite);
  			var w = a.owner.weapon.sprite;
			if (w != null) {
				FlxG.overlap(mobSprites, w.group, hitActor);
			}
		}
	}
	
	public function hitWall(m:MapSprite, b:Bullet) {
		var e = cast(b.weapon.parent, ActorSprite).explosionEmitter;
		e.explode(b.x, b.y);
		b.kill();
	}
	
	public function hitActor(a:ActorSprite, b:Bullet) {
		var attacker = cast(b.weapon.parent, ActorSprite).owner;
		var victim = a.owner;
		
		if (attacker == victim) {
			return;
		}
		
		var isHit = attacker.weapon.hit(victim);
		if (isHit) {
			var e = a.bloodEmitter;
			e.explode(a.x+Registry.tileSize/2, a.y+Registry.tileSize/2);
		}
		
		b.kill();
	}
	
	public function overlapItem(a:ActorSprite, i:ActorSprite) {
		if (i.owner.triggerable != null)
			i.owner.triggerable.onBump(a.owner);
	}
}