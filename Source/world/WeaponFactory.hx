package world;

import data.Registry;
import sprites.WeaponSprite;
import world.Weapon;

class WeaponFactory {
	public static function newWeapon(owner:Actor, type:WeaponType):Weapon {
		var w = new Weapon(owner, type);
		w.sprite = new WeaponSprite(Type.enumConstructor(type));
		
		switch (type) {
			case UNARMED:	
				w.range = Registry.rangeShort;
			case SPEAR:
				w.range = Registry.rangeShort;
			case SWORD:
				w.range = Registry.rangeShort;
			case BOW:
				w.range = Registry.rangeLong;
			case STAFF:
				w.range = Registry.rangeShort;
		}
		
		var color = 0xffffffff;
		w.sprite.makePixelBullet(Registry.bulletsPerWeapon, 2, 2, color);
		
		// fixme - calculate from dext
		w.sprite.setFireRate(300);
		
		w.sprite.setBulletLifeSpan(Std.int(  1000/(Registry.bulletSpeed/(w.range*Registry.tileSize))  ));
		
		return w;
	}
}