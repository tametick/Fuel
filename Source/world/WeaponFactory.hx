package world;

import org.flixel.FlxG;
import sprites.WeaponSprite;
import data.Registry;
import parts.WeaponPart;

class WeaponFactory {
	public static function newWeapon(owner:Actor, type:WeaponType):WeaponPart {
		var w = new WeaponPart(owner, type);
		w.sprite = new WeaponSprite(w, type);
		var bulletColor = 0;
		
		switch (type) {
			case UNARMED:
				w.range = Registry.rangeShort;
				w.damage = 1;
			case LASER:
				w.range = Registry.rangeLong;
				w.damage = 1;
		}
		
		// fixme - use bullet sprite
		if (w.range == Registry.rangeLong) {
			bulletColor = 0xffFFFF80;
		}
		w.sprite.makePixelBullet(Registry.bulletsPerWeapon, 2, 2, bulletColor);
		w.sprite.setBulletBounds(FlxG.worldBounds);
		
		return w;
	}
}