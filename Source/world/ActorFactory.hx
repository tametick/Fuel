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
		var index;
		var sheet:Image;
		var isImmovable = false;

		switch (type) {
			case ARCHER:
				a.isPlayer = true;
				sheet = HEROES;
				index = 1;
				a.addPart(new StatsPart({
					maxHealth:1,
					maxGun:1,
					maxBelt:1
				}));
				a.addPart(WeaponFactory.newWeapon(a, BOW));
				a.addPart(new TriggerablePart(true));

			// monsters
			case SPEAR_DUDE:
				sheet = HUMANS;
				index = 1;
				a.addPart(new StatsPart({
					maxHealth:1,
				}));
				a.addPart(WeaponFactory.newWeapon(a, UNARMED));
				a.addPart(new TriggerablePart(true));
		}

		a.sprite = new ActorSprite(a, sheet, index, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}

		if(a.stats != null) {
			a.stats.health = a.stats.maxHealth;
			a.stats.gun= a.stats.maxGun;
			a.stats.belt = a.stats.maxBelt;
		}

		return a;
	}
}