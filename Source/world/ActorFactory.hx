package world;

import sprites.ActorSprite;
import data.Registry;
import data.Library;
import world.Actor;
import world.Weapon;

class ActorFactory {
	public static function newActor(type:ActorType, ?x:Float=1, ?y:Float=1):Actor {
		var a = new Actor(type);
		var index;
		var sheet:Images;
		var isImmovable = false;

		switch (type) {
			// player classes
			case MONK:
				a.isPlayer = true;
				sheet = HEROES;
				index = 0;
				a.addPart(new StatsPart({
					 strength: 4,
           dexterity: 3,
					 agility: 6,
					 endurance: 10,
        }));
				a.weapon = WeaponFactory.newWeapon(a, STAFF);

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
				a.weapon = WeaponFactory.newWeapon(a, BOW);

			case WARRIOR:
				a.isPlayer = true;
				sheet = HEROES;
				index = 2;
				a.addPart(new StatsPart({
           strength: 6,
           dexterity: 9,
           agility: 5,
           endurance: 3,
        }));
				a.weapon = WeaponFactory.newWeapon(a, SWORD);

			case GUARD:
				a.isPlayer = true;
				sheet = HEROES;
				index = 3;
				a.addPart(new StatsPart({
           strength: 8,
           dexterity: 5,
           agility: 4,
           endurance: 6,
        }));
				a.weapon = WeaponFactory.newWeapon(a, SPEAR);

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
				a.weapon = WeaponFactory.newWeapon(a, SPEAR);
				a.isBlocking = true;


			// level features
			case LEVER_CLOSE:
				sheet = FURNITURE2;
				index = 0;
			case LEVER_OPEN:
				sheet = FURNITURE2;
				index = 1;
			case DOOR_CLOSE:
				sheet = DOORS;
				index = 2;
				a.isBlocking = true;
			case DOOR_OPEN:
				sheet = DOORS;
				index = 12;
		}

		a.sprite = new ActorSprite(a, sheet, index, x * Registry.tileSize, y * Registry.tileSize, a.isBlocking);
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}

		if(a.stats != null) {
			if (a.stats.strength != 0 && a.stats.endurance != 0) {
				a.stats.health = a.stats.maxHealth;
			} else {
				a.stats.health = 1;
			}
		}

		return a;
	}
}