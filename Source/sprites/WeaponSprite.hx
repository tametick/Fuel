package sprites;

import org.flixel.plugin.photonstorm.FlxWeapon;

class WeaponSprite extends FlxWeapon {
	public static var UP(getUp, never):Int;
	public static var DOWN(getDown, never):Int;
	public static var LEFT(getLeft, never):Int;
	public static var RIGHT(getRight, never):Int;
	
	public static inline function getUp():Int { return FlxWeapon.BULLET_UP; }
	public static inline function getDown():Int { return FlxWeapon.BULLET_DOWN; }
	public static inline function getLeft():Int { return FlxWeapon.BULLET_LEFT; }
	public static inline function getRight():Int { return FlxWeapon.BULLET_RIGHT; }
	
}