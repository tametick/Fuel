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
				a.strength = 4;
				a.dexterity = 4;
				a.agility = 5;
				a.endurance = 10;
				a.weapon = WeaponFactory.newWeapon(a, STAFF);
				
			case ARCHER:
				a.isPlayer = true;
				sheet = HEROES;
				index = 1;
				a.strength = 3;
				a.dexterity = 8;
				a.agility = 10;
				a.endurance = 2;
				a.weapon = WeaponFactory.newWeapon(a, BOW);
				
			case WARRIOR:
				a.isPlayer = true;
				sheet = HEROES;
				index = 2;
				a.strength = 6;
				a.dexterity = 10;
				a.agility = 3;
				a.endurance = 4;
				a.weapon = WeaponFactory.newWeapon(a, SWORD);
				
			case GUARD:
				a.isPlayer = true;
				sheet = HEROES;
				index = 3;
				a.strength = 10;
				a.dexterity = 5;
				a.agility = 2;
				a.endurance = 6;
				a.weapon = WeaponFactory.newWeapon(a, SPEAR);
				
			// monsters
				
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
				isImmovable = true;
			case DOOR_OPEN:
				sheet = DOORS;
				index = 12;
				isImmovable = true;
		}
		
		a.sprite = new ActorSprite(a, sheet, index, x * Registry.tileSize, y * Registry.tileSize, isImmovable);
		if(a.weapon!=null) {
			a.weapon.sprite.setParent(a.sprite, "x", "y",Std.int(Registry.tileSize/2-1), Std.int(Registry.tileSize/2-1));
		}
		
		if(a.strength!=0 && a.endurance!=0) {
			a.health = a.maxHealth;
		} else {
			a.health = 1;
		}
		
		return a;
	}	
}