package sprites;

import com.eclecticdesignstudio.motion.Actuate;
import data.Library;
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
import nme.display.BitmapInt32;

import org.flixel.FlxObject;

class MapSprite extends FlxTilemap {
	public var owner:Level;

	public var itemSprites:FlxGroup;
	public var mobSprites:FlxGroup;
	public var bulletSprites(getBulletSprites, null):FlxGroup;
	
	public function findTilePath(start:FlxPoint, end:FlxPoint):FlxPath {
		var s = new FlxPoint(start.x*_tileWidth, start.y*_tileHeight);
		var e = new FlxPoint(end.x*_tileWidth, end.y*_tileHeight);
		
		return findPath(s, e, false);
	}
	
	public function new(owner:Level) {
		super();
		this.owner = owner;
		var tileGraphics = Library.getFilename(LEVEL);
		loadMap(FlxTilemap.arrayToCSV(owner.tiles, Registry.levelWidth), tileGraphics, 13, 13, FlxTilemap.AUTO);
		updateTileSheet();
	}
	
	public function setColor(c:BitmapInt32) {
		
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
					Actuate.update(setDarkness, 1/(Registry.walkingSpeed), [oldDarkness], [newDarkness]);
				}
			}
		}
	}
		
	function getBulletSprites():FlxGroup {
		// only calculated when creating new level
		if (bulletSprites != null) {
			return bulletSprites;
		}
		
		bulletSprites = new FlxGroup();
		for (a in owner.actors) {
			if (a.weapon != null) {
				bulletSprites.add(a.weapon.sprite.group);
			}
		}
		return bulletSprites;
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
		
		//try {
			FlxG.overlap(mobSprites, bulletSprites, hitActor);
		//} catch (err:Dynamic) {
			//if(Registry.debug) {
//				trace(err);
	//		}
	//	}
		if(Registry.player.sprite.alive){
			FlxG.overlap(Registry.player.sprite, mobSprites, overlapWithEnemy);
		}
		FlxG.collide(this, bulletSprites, hitWall);
	}
	
	function overlapWithEnemy(f1:FlxObject, f2:FlxObject) : Void {
		var victim:ActorSprite = cast(f1, ActorSprite);
		var killer:ActorSprite = cast(f2, ActorSprite);
		
		if(Utils.exists([CLIMBER, WALKER, FLYER, CEILING_SPIKE], killer.owner.type))
			Registry.player.kill();
	}
	
	public function hitWall(f1:FlxObject, f2:FlxObject):Void {
		var m:MapSprite = cast(f1, MapSprite);
		var b:Bullet = cast(f2, Bullet);
		
		FlxG.play(Library.getSound(DESTROY_WALL));
		
		var shooter = cast(b.weapon.parent, ActorSprite);
		var e = shooter.explosionEmitter;
		e.explode(b.x, b.y);
		
		var tx = b.x / Registry.tileSize;
		var ty = b.y / Registry.tileSize;
		
		tx += shooter.direction.dx;
		ty += shooter.direction.dy;
		
		owner.set(tx, ty, 0);
		owner.updateFov(Registry.player.tilePoint);
		b.kill();
		
		//if (shooter.owner == Registry.player) {
		// look at actor above
		var fallingVictims = owner.getActorAtPoint(tx, ty - 1);
		for(fallingVictim in fallingVictims) {
			if(fallingVictim.stats != null || fallingVictim.type == ActorType.FLOOR_SPIKE || fallingVictim.type == ActorType.MINERAL) {
				fallingVictim.sprite.fall();
			}
		}
		
		// look at actor below
		fallingVictims = owner.getActorAtPoint(tx, ty + 1);
		for(fallingVictim in fallingVictims) {
			if (fallingVictim.isHung) {
				fallingVictim.sprite.play("falling");
				fallingVictim.sprite.fall();
			}
		}
		//}
	}
	
	public function hitActor(f1:FlxObject, f2:FlxObject) : Void {
		var a:ActorSprite = cast (f1, ActorSprite);
		var b:Bullet = cast (f2, Bullet);
		
		var attacker = cast(b.weapon.parent, ActorSprite).owner;
		var victim = a.owner;
		
		if (attacker == victim) {
			return;
		}
		
		attacker.weapon.hit(victim);
		a.bloodEmitter.explode(a.x+Registry.tileSize/2, a.y+Registry.tileSize/2);
		b.kill();
	}
	
	public function overlapItem(f1:FlxObject, f2:FlxObject) : Void {
		var a:ActorSprite = cast (f1, ActorSprite);
		var i:ActorSprite = cast (f2, ActorSprite);
		if (i.owner.triggerable != null)
			i.owner.triggerable.onBump(a.owner);
	}
}