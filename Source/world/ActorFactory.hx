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
					strength: 3,
					dexterity: 9,
					agility: 9,
					endurance: 2,
				}));
				a.addPart(WeaponFactory.newWeapon(a, BOW));
				a.addPart(new TriggerablePart(true));

			// monsters
			case SPEAR_DUDE:
				sheet = HUMANS;
				index = 1;
				a.addPart(new StatsPart({
					strength: 2,
					dexterity: 2,
					agility: 2,
					endurance: 4,
				}));
				a.addPart(WeaponFactory.newWeapon(a, SPEAR));
				a.addPart(new TriggerablePart(true));
		}

		a.sprite = new ActorSprite(a, sheet, index, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}

		if(a.stats != null) {
			a.stats.health = a.stats.maxHealth;
		}

		return a;
	}
}