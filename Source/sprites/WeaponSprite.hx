package sprites;

import org.flixel.plugin.photonstorm.FlxWeapon;
import data.Registry;
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

	override function getBulletLifeSpan():Int {
		return Std.int( 1000/(Registry.bulletSpeed/(owner.range*Registry.tileSize)) );
	}
}