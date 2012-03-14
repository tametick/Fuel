package world;

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
		var sheet:Image;
		var isImmovable = false;

		switch (type) {
			case SPACE_MINER:
				a.isPlayer = true;
				sheet = CHARACTER;
				a.addPart(new StatsPart({
					maxSuitCharge:1,
					maxGunCharge:1,
					maxBeltCharge:1
				}));
				a.addPart(WeaponFactory.newWeapon(a, LASER));
				a.addPart(new TriggerablePart(true));
				a.sprite = new ActorSprite(a, sheet, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
				a.sprite.addAnimation("idle", [0, 1], 1);
				a.sprite.addAnimation("run", [2, 3], 10);
				a.sprite.addAnimation("shoot", [8, 9], 10, false);
				a.sprite.addAnimation("fly", [12, 13], 10);
				a.sprite.addAnimation("fall", [14, 15], 10);
				a.weapon.sprite.setPreFireCallback( function() { a.sprite.play("shoot", true); } );
				a.sprite.setColor(0xb2d47d);

			// monsters
			case WALKER:
				//sheet = FLOOR_WALKER;
				sheet = CHARACTER;
				a.addPart(new StatsPart({
					maxSuitCharge:1,
				}));
				a.addPart(WeaponFactory.newWeapon(a, UNARMED));
				a.addPart(new TriggerablePart(true));
				a.sprite = new ActorSprite(a, sheet, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
				a.sprite.addAnimation("idle", [0, 1], 1);
				a.sprite.addAnimation("run", [2, 3], 10);
				a.sprite.addAnimation("shoot", [8, 9], 10, false);
				a.sprite.addAnimation("fly", [12, 13], 10);
				a.sprite.addAnimation("fall", [14, 15], 10);
				a.sprite.setColor(0x800000);
		}
		a.sprite.initBars();
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
}