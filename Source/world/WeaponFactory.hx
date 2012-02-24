package world;

import data.Registry;
import sprites.WeaponSprite;
import world.Weapon;

class WeaponFactory {
	public static function newWeapon(owner:Actor, type:WeaponType):Weapon {
		var w = new Weapon(owner, type);
		w.sprite = new WeaponSprite(w, type);
		
		switch (type) {
			case UNARMED:	
				w.range = Registry.rangeShort;
				w.damage = 1;
				w.attackSpeed = 4;
				w.accuracy = 4;
			case SPEAR:
				w.range = Registry.rangeShort;
				w.damage = 6;
				w.attackSpeed = 2;
				w.accuracy = 3;
			case SWORD:
				w.range = Registry.rangeShort;
				w.damage = 4;
				w.attackSpeed = 3;
				w.accuracy = 4;
			case BOW:
				w.range = Registry.rangeLong;
				w.damage = 2;
				w.attackSpeed = 3;
				w.accuracy = 4;
			case STAFF:
				w.range = Registry.rangeShort;
				w.damage = 3;
				w.attackSpeed = 2;
				w.accuracy = 5;
		}
		
		w.defense = 0;
		
		var color = 0xffffffff;
		w.sprite.makePixelBullet(Registry.bulletsPerWeapon, 2, 2, color);
		
		return w;
	}
}