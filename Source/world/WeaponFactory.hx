package world;

import sprites.WeaponSprite;
import thx.csv.Csv;
import data.Library;
import data.Registry;
import world.Weapon;

class WeaponFactory {
	public static function newWeapon(owner:Actor, type:WeaponType):Weapon {
		var defs = Library.getDefinition(WEAPONS);
		
		var w = new Weapon(owner, type);
		w.sprite = new WeaponSprite(w, type);
		var bulletColor = 0;
		
		switch (type) {
			case UNARMED:
				w.range = Registry.rangeShort;
				w.damage = 1;
				w.attackSpeed = 4;
				w.accuracy = 4;
				w.defense = 0;
			case SPEAR:
				w.range = Registry.rangeShort;
				w.damage = 6;
				w.attackSpeed = 2;
				w.accuracy = 3;
				w.defense = 0;
			case SWORD:
				w.range = Registry.rangeShort;
				w.damage = 4;
				w.attackSpeed = 3;
				w.accuracy = 4;
				w.defense = 0;
			case BOW:
				w.range = Registry.rangeLong;
				w.damage = 2;
				w.attackSpeed = 3;
				w.accuracy = 4;
				w.defense = 0;
			case STAFF:
				w.range = Registry.rangeShort;
				w.damage = 3;
				w.attackSpeed = 2;
				w.accuracy = 5;
				w.defense = 0;
		}
		
		// fixme - use bullet sprite
		if (w.range == Registry.rangeLong) {
			bulletColor = 0xffFFFF80;
		}
		w.sprite.makePixelBullet(Registry.bulletsPerWeapon, 2, 2, bulletColor);
		
		return w;
	}
}