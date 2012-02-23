package world;

import sprites.WeaponSprite;
import world.Weapon;

class WeaponFactory {
	public static function newWeapon(owner:Actor, type:WeaponType):Weapon {
		var w = new Weapon(owner, type);
		w.sprite = new WeaponSprite(Type.enumConstructor(type));
		
		switch (type) {
			case SPEAR:
				w.range = 1;
		}
		
		return w;
	}
}