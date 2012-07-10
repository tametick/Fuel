package sprites;

import org.flixel.plugin.photonstorm.FlxWeapon;
import data.Registry;
import utils.Direction;
import world.Actor;
import parts.WeaponPart;

class WeaponSprite extends FlxWeapon {
	var owner:WeaponPart;
	
	public static var UP(getUp, never):Int;
	public static var DOWN(getDown, never):Int;
	public static var LEFT(getLeft, never):Int;
	public static var RIGHT(getRight, never):Int;
	
	public static inline function getUp():Int { return FlxWeapon.BULLET_UP; }
	public static inline function getDown():Int { return FlxWeapon.BULLET_DOWN; }
	public static inline function getLeft():Int { return FlxWeapon.BULLET_LEFT; }
	public static inline function getRight():Int { return FlxWeapon.BULLET_RIGHT; }
	
	
	public function new(owner:WeaponPart, type:WeaponType) {
		this.owner = owner;
		super(Type.enumConstructor(type));
	}

	public function getBulletLifeSpan():Int {
		return Std.int( 1000/(Registry.bulletSpeed/(owner.range*Registry.tileSize)) );
	}
	
	public function getFacing(d:Direction) {
		if (d.dx == -1) return FlxWeapon.BULLET_LEFT;
		if (d.dx == 1) return FlxWeapon.BULLET_RIGHT;
		if (d.dy == -1) return FlxWeapon.BULLET_UP;
		if (d.dy == 1) return FlxWeapon.BULLET_DOWN;
		
		return 0;
	}
}