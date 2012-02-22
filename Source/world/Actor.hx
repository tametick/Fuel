package world;

import data.Registry;
import org.flixel.plugin.photonstorm.FlxWeapon;
import sprites.ActorSprite;

class Actor {
	public var type:ActorType;
	public var sprite:ActorSprite;
	public var weapon:FlxWeapon;
	
	public var items:Array<Actor>;
	public var tileX(getX, setX):Float;
	public var tileY(getY, setY):Float;
	
	public function new(type:ActorType) {
		this.type = type;
		items = [];
	}
	
	function getX():Float {
		return sprite.x / Registry.tileSize;
	}
	function getY():Float {
		return sprite.y / Registry.tileSize;
	}
	
	function setX(x:Float):Float {
		var offset = (type==PLAYER? Registry.playerHitboxOffset:0);
		sprite.x = x * Registry.tileSize+Std.int(offset/2);
		return getX();
	}
	function setY(y:Float):Float {
		var offset = (type==PLAYER? Registry.playerHitboxOffset:0);
		sprite.y = y * Registry.tileSize+offset;
		return getY();
	}
	
	public function has(type:ActorType):Bool {
		for (item in items) {
			if (item.type == type) {
				return true;
			}
		}
		return false;
	}
	
	public function remove(type:ActorType) {
		for (item in items.copy()) {
			if (item.type == type) {
				items.remove(item);
				return;
			}
		}
	}

}

enum ActorType {
	PLAYER;
	LEVER_CLOSE;
	LEVER_OPEN;
	DOOR_CLOSE;
	DOOR_OPEN;
}