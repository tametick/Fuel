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
				sheet = HEROES;
				index = 0;
				a.weapon = WeaponFactory.newWeapon(a, STAFF);
				a.isPlayer = true;
			case ARCHER:
				sheet = HEROES;
				index = 1;
				a.weapon = WeaponFactory.newWeapon(a, BOW);
				a.isPlayer = true;
			case WARRIOR:
				sheet = HEROES;
				index = 2;
				a.weapon = WeaponFactory.newWeapon(a, SWORD);
				a.isPlayer = true;
			case GUARD:
				sheet = HEROES;
				index = 3;
				a.weapon = WeaponFactory.newWeapon(a, SPEAR);
				a.isPlayer = true;

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
		return a;
	}	
}