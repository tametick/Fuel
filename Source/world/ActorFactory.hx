package world;

import parts.SpikeTriggerablePart;
import sprites.ActorSprite;
import data.Registry;
import data.Library;
import parts.DoorTriggerablePart;
import parts.StatsPart;
import parts.TriggerablePart;
import parts.WeaponPart;
import world.Actor;


class ActorFactory {
	public static function newActor(type:ActorType, ?x:Float=1, ?y:Float=1):Actor {
		var a = new Actor(type);
		var isImmovable = false;

		switch (type) {
			case SPACE_MINER:
				a.isPlayer = true;
				a.addPart(new StatsPart({
					maxSuitCharge:1,
					maxGunCharge:1,
					maxBeltCharge:1
				}));
				a.addPart(WeaponFactory.newWeapon(a, LASER));
				a.addPart(new TriggerablePart(true));
				a.sprite = newSprite(a,CHARACTER,x,y);
				a.sprite.addAnimation("idle", [0, 1], 1);
				a.sprite.addAnimation("run", [2, 3], 10);
				a.sprite.addAnimation("shoot", [8, 9], 10, false);
				a.sprite.addAnimation("fly", [12, 13], 10);
				a.sprite.addAnimation("fall", [14, 15], 10);
				a.weapon.sprite.setPreFireCallback( function() { a.sprite.play("shoot", true); } );
				a.sprite.setColor(0xb2d47d);


			// monsters
			case WALKER:
				a.addPart(new StatsPart({
					maxSuitCharge:1,
				}));
				a.addPart(WeaponFactory.newWeapon(a, UNARMED));
				a.addPart(new TriggerablePart(true));
				//sheet = FLOOR_WALKER;
				a.sprite = newSprite(a,CHARACTER,x,y);
				a.sprite.addAnimation("idle", [0, 1], 1);
				a.sprite.addAnimation("run", [2, 3], 10);
				a.sprite.addAnimation("shoot", [8, 9], 10, false);
				a.sprite.addAnimation("fly", [12, 13], 10);
				a.sprite.addAnimation("fall", [14, 15], 10);
				a.sprite.setColor(0x800000);
				
				
			// map features
			case CEILING_SPIKE:
				a.addPart(new SpikeTriggerablePart());
				a.sprite = newSprite(a, STALAGMITES, x, y);
				a.sprite.addAnimation("idle", [0]);
				a.sprite.setColor(0x6c2d37);

			case FLOOR_SPIKE:
				a.addPart(new SpikeTriggerablePart());
				a.sprite = newSprite(a, STALAGMITES, x, y);
				a.sprite.addAnimation("idle", [3]);
				a.sprite.setColor(0x6c2d37);
				
		}
		if(a.stats!=null) {
			a.sprite.initBars();
		}
		a.sprite.play("idle");
		
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}

		if(a.stats != null) {
			a.stats.suitCharge = a.stats.maxSuitCharge;
			a.stats.gunCharge= a.stats.maxGunCharge;
			a.stats.beltCharge = a.stats.maxBeltCharge;
		}

		return a;
	}
	
	static function newSprite(a:Actor,sheet:Image, x:Float ,y:Float):ActorSprite {
		return new ActorSprite(a, sheet, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
	}
}